# Performance

Some of the performance features Nixtra employs are, but not limited to:

- EarlyOOM: close demanding applications when you are about to run out of memory; prevent kernel panics preemptively
- zram: compressed memory; require less physical memory for apps
- zswap: compressed swap file
- Automatic CPU governmance management
- TLP: power management for laptops
- IRQ balancing: distribute hardware interrupts (IRQs) across multiple CPU cores; optimize performance and reduce CPU bottlenecks
- System library preloading: monitor what applications are used most often and predictively load binaries and libraries into memory; faster initialization
- Improved TCP congestion algorithms: faster networking
- NIC offloading: reduce load on CPU for specific network tasks (for supported controllers)
- Improved block scheduling: slightly better performance on NVMe SSDs
- KSM (Kernel Samepage Merging): detect identical memory pages among different processes and merge them into a single shared page; save ram
