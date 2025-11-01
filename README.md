# GNOME Extensions Action

A GitHub Action that packages and uploads GNOME Shell extensions to extensions.gnome.org.

## Usage

```yaml
- name: Package and Upload Extension
  uses: murar8/gnome-extensions-action@0.1.0
  with:
    source-dir: ./my-extension
    username: ${{ secrets.GNOME_USERNAME }}
    password: ${{ secrets.GNOME_PASSWORD }}
    accept-tos: true
```

## Inputs

| Input | Description | Required | Default |
|-------|-------------|----------|---------|
| `source-dir` | Extension source directory | No | `.` |
| `output-dir` | Package output directory | No | `.` |
| `extra-source` | Additional source files to include (newline-separated for multiple files) | No | |
| `schema` | GSettings schema that should be included | No | |
| `podir` | Directory where translations are found | No | |
| `gettext-domain` | Gettext domain to use for translations | No | |
| `force` | Overwrite an existing pack | No | `false` |
| `username` | Username for extensions.gnome.org (skip upload if not provided) | No | |
| `password` | Password for extensions.gnome.org (skip upload if not provided) | No | |
| `accept-tos` | Accept the GNOME Extensions Developer Agreement | No | `false` |

## Outputs

| Output | Description |
|--------|-------------|
| `zip-file` | Path to the created `.shell-extension.zip` file |

## Examples

### Package only (no upload)

```yaml
- uses: murar8/gnome-extensions-action@0.1.0
  with:
    source-dir: ./extension
```

### Package and upload

```yaml
- uses: murar8/gnome-extensions-action@0.1.0
  with:
    source-dir: ./extension
    username: ${{ secrets.GNOME_USERNAME }}
    password: ${{ secrets.GNOME_PASSWORD }}
    accept-tos: true
```

### Package with extra source files

```yaml
- uses: murar8/gnome-extensions-action@0.1.0
  with:
    source-dir: ./extension
    extra-source: |
      ./extra-file-1.js
      ./extra-file-2.js
```

## Development

### Run tests

```bash
./test.sh
```

### Build image

```bash
docker build -t gnome-extensions-action .
```
