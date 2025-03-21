import os
import json
import sys
import tty
import termios

def get_key():
    if os.name == 'nt':
        # Windows
        import msvcrt
        if not msvcrt.kbhit():
            return None
        first = msvcrt.getch()
        if first == b'\xe0':  # Arrow keys
            second = msvcrt.getch()
            arrows = {b'H': 'up', b'P': 'down',
                     b'K': 'left', b'M': 'right'}
            return arrows.get(second)
        return first.decode('utf-8').lower()
    else:
        # Unix-like
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
            if ch == '\x1b':  # Escape sequence
                ch = sys.stdin.read(1)
                if ch == '[':  # Arrow keys
                    key = sys.stdin.read(1)
                    arrows = {'A': 'up', 'B': 'down',
                            'D': 'left', 'C': 'right'}
                    return arrows.get(key)
            return ch.lower()
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)

def load_existing_assets(file_path):
    try:
        with open(file_path, 'r') as f:
            return {asset['path']: asset for asset in json.load(f)}
    except (FileNotFoundError, json.JSONDecodeError):
        return {}

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def get_file_extensions(assets):
    # Get unique extensions from all files
    extensions = set()
    ignored_extensions = {'.bin', '.bios', '.txt', '.json'}
    for asset in assets:
        ext = os.path.splitext(asset['file'])[1].lower()
        if ext and ext not in ignored_extensions:  # Only add if extension exists and not ignored
            extensions.add(ext)
    return ['All'] + sorted(list(extensions))

def filter_assets_by_extension(assets, extension):
    if extension == 'All':
        return assets
    return [asset for asset in assets if os.path.splitext(asset['file'])[1].lower() == extension]

def display_page(assets, page, page_size, selected_indices, current_extension):
    clear_screen()
    start_idx = page * page_size
    end_idx = start_idx + page_size
    page_assets = assets[start_idx:end_idx]
    total_pages = (len(assets) + page_size - 1) // page_size
    
    print(f"\nFilter: {current_extension}")
    print(f"Page {page + 1}/{total_pages}")
    print("-" * 50)
    for idx, asset in enumerate(page_assets, start=start_idx):
        num = str((idx + 1) % 10)  # Convert 10 to 0
        status = "x" if (idx + 1) in selected_indices else " "
        new_flag = " (NEW)" if asset.get('new', False) else ""
        print(f"{num}. [{status}] {asset['file']}{new_flag}")
    print("-" * 50)
    print("\nControls: 0-9 to toggle, ←/→ for pages, z/x to change filter, q to finish")

def get_user_selections(assets):
    page_size = 10
    selected_indices = set()
    extensions = get_file_extensions(assets)
    extension_idx = 0
    current_extension = extensions[0]  # Start with 'All'
    filtered_assets = assets
    
    # Initialize selected_indices with currently included assets
    for idx, asset in enumerate(assets):
        if asset.get('included', False):
            selected_indices.add(idx + 1)
    
    current_page = 0
    
    while True:
        display_page(filtered_assets, current_page, page_size, selected_indices, current_extension)
        
        # Get keypress without waiting for enter
        key = get_key()
        if key is None:
            continue
        
        total_pages = (len(filtered_assets) + page_size - 1) // page_size
        
        if key == 'q':
            break
        elif key == 'right' and current_page < total_pages - 1:
            current_page += 1
        elif key == 'left' and current_page > 0:
            current_page -= 1
        elif key == 'z':  # Previous filter
            extension_idx = (extension_idx - 1) % len(extensions)
            current_extension = extensions[extension_idx]
            filtered_assets = filter_assets_by_extension(assets, current_extension)
            current_page = 0  # Reset to first page when changing filter
        elif key == 'x':  # Next filter
            extension_idx = (extension_idx + 1) % len(extensions)
            current_extension = extensions[extension_idx]
            filtered_assets = filter_assets_by_extension(assets, current_extension)
            current_page = 0  # Reset to first page when changing filter
        elif key in '0123456789':
            # Convert 0 to 10 for the last item
            num = int(key)
            if num == 0:
                num = 10
            
            # Calculate actual index based on current page
            actual_idx = current_page * page_size + num
            
            # Find the corresponding index in the original assets list
            if 1 <= actual_idx <= len(filtered_assets):
                filtered_asset = filtered_assets[actual_idx - 1]
                original_idx = assets.index(filtered_asset) + 1
                if original_idx in selected_indices:
                    selected_indices.remove(original_idx)
                else:
                    selected_indices.add(original_idx)
    
    return selected_indices

def crawl_directory(directory, existing_assets):
    assets = []
    script_dir = os.path.dirname(os.path.abspath(__file__))
    for root, _, files in os.walk(directory):
        for file in files:
            abs_path = os.path.join(root, file)
            # Make path relative to script directory
            rel_path = os.path.relpath(abs_path, script_dir)
            if rel_path in existing_assets:
                # Use existing asset data but ensure 'new' is not present
                asset_data = existing_assets[rel_path].copy()
                asset_data.pop('new', None)
                assets.append(asset_data)
            else:
                # Add new asset with 'new' flag
                assets.append({
                    "file": file,
                    "path": rel_path,
                    "included": False,
                    "new": True
                })
    
    # Sort assets to put new files at the top
    assets.sort(key=lambda x: (not x.get('new', False), x['file'].lower()))
    return assets

def save_assets_json(assets, output_file):
    with open(output_file, 'w') as f:
        json.dump(assets, f, indent=4)
    
    # Save included files to files.txt
    files_txt = os.path.join(os.path.dirname(output_file), "files.txt")
    with open(files_txt, 'w') as f:
        for asset in assets:
            if asset.get('included', False):
                f.write(asset['path'] + '\n')
    
    print("\nAssets have been updated and saved to assets.json")
    print("Included files list saved to files.txt")
    print("\nSuggested rsync command:")
    print("rsync -av --delete --files-from=files.txt . /mnt/d/Assets/")

if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))
    output_file = os.path.join(script_dir, "assets.json")
    
    # Load existing assets
    existing_assets = load_existing_assets(output_file)
    
    # Crawl directory and update assets
    assets = crawl_directory(script_dir, existing_assets)
    
    # Get user selections
    print("\nSelect assets to include:")
    selected_indices = get_user_selections(assets)
    
    # Update assets based on selections
    for idx, asset in enumerate(assets):
        asset['included'] = (idx + 1) in selected_indices
        asset.pop('new', False)  # Remove new flag from all assets
    
    # Save updated assets
    save_assets_json(assets, output_file) 