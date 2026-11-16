#include <linux/init.h>
#include <linux/module.h>
#include <linux/kernel.h>

/* Meta Information */
MODULE_LICENSE("GPL");
MODULE_AUTHOR("Developer");
MODULE_DESCRIPTION("A simple Linux Kernel Module for ARM cross-compilation");
MODULE_VERSION("0.1");

/**
 * @brief This function is called when the module is loaded into the kernel (insmod).
 */
static int __init my_module_init(void) {
    pr_info("MyModule: Module loaded successfully!\n");
    return 0; // Non-zero return means a failure, loading will abort.
}

/**
 * @brief This function is called when the module is removed from the kernel (rmmod).
 */
static void __exit my_module_exit(void) {
    pr_info("MyModule: Module unloaded successfully.\n");
}

/* Module entry and exit points */
module_init(my_module_init);
module_exit(my_module_exit);