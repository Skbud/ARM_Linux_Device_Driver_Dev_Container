## c_cpp_properties.json
- **What it does:** Tells the C/C++ IntelliSense extension (ms-vscode.cpptools) where to find header files, include paths, compiler paths, and what C/C++ standard to use.

- **Why you need it:** Without it, you will see annoying red squiggles under standard library headers (like `#include <stdio.h>` or Linux kernel headers) because IntelliSense doesn't know where your cross-launch.json

## tasks.json
- **What it does:** Defines build tasks—how VS Code should compile your code using tools like gcc, make, or cmake.

- **Why you need it:** It maps a shortcut (like Ctrl+Shift+B) to a shell command (such as running your make command or invoking your arm-linux-gnueabihf-gcc cross-compiler) so you don't have to type it manually every time.

***Tip:*** if you want to add additional shortcuts apart from(shift+ctl+b) as it runs the default marked then edit `Preferences: Open Keyboard Shortcuts (JSON)` with the args from task.json like 
```json
    {
        "key": "ctrl+shift+c",
        "command": "workbench.action.tasks.runTask",
        "args": "Clean LKM"
    }
```

## launch.json
- **What it does:** Configures the debugger (gdb or lldb) specifying how VS Code should start your program, where to attach breakpoints, and what arguments to pass.

- **Why you need it:** When you press F5 to debug, this file tells the debugger how to launch your compiled binary (and allows you to debug code running inside your dev container seamlessly).

## settings.json
- **What it does:** Manages workspace-specific VS Code preferences (like tab sizes, default terminal behavior, formatting rules, or CMake auto-configure settings).

- **Why you need it:** It keeps your editor customized specifically for this project's needs (e.g., forcing 4-space indentation or automatically running CMake on project open) without altering your global VS Code settings.