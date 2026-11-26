#!/usr/bin/env bash
if [ -x /usr/bin/gdb ]; then
  exec /usr/bin/gdb "$@"
fi

sysroot="${HOME}/.local/sysroot"
if [ -x "${sysroot}/usr/bin/gdb" ]; then
  export LD_LIBRARY_PATH="${sysroot}/usr/lib/x86_64-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
  exec "${sysroot}/usr/bin/gdb" "$@"
fi

prefix="${HOME}/.local/host-cpp"
if [ -x "${prefix}/bin/gdb" ]; then
  export PATH="${prefix}/bin:${PATH}"
  export LD_LIBRARY_PATH="${prefix}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
  exec "${prefix}/bin/gdb" "$@"
fi

echo "gdb was not found. Install gdb, or place it in ${sysroot}." >&2
exit 1
