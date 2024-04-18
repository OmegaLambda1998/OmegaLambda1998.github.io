@def tabname="Fixing a broken kernel"
@def title="Don't panic after a kernel panic"
@def subtitle="Recovering after my system *expletives* the bed"
@def authors="Patrick Armstrong"

The laptop I'm writing this on is a 7th Gen Thinkpax X1 Carbon running Arch Linux with Wayland. This seems to tick every box of "obnoxious tech bro" so assuming you haven't closed your browser in disgust, I want to briefly go over a no good, very bad morning of system crashes and kernel panics, and how I resolved it. This is more a reminder to myself for when I inevitably brick my system after unecessary tinkering.

## How to kill your system in a few easy steps
So, let's set the scene. Last year I was dissapointed in the battery life of my system and did some errant searching for improvements I could make. This led to me installing [TLP](https://wiki.archlinux.org/title/TLP), enabling the systemd service, and promptly forgetting about it. Cut to last week where another bout of searching for ways to break my system in the name of "optimisation" leads me to installing [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq). Of course, like any good programmer, I read the documentation, which included this:

Please note: auto-cpufreq aims to replace TLP in terms of functionality, so after you install auto-cpufreq it's recommended to remove TLP. Using both for the same functionality (i.e., to set CPU frequencies) will lead to unwanted results like overheating. Hence, only use both tools in tandem if you know what you're doing.

"Ah", I thought, "That's fine, I'm pretty sure I'm not using TLP, onwards!". And now, you are ready to understand my folly.

This morning, I was running a system upgrade which included updates to both the linux and linux-zen kernels. Everything was going swimmingly, the kernels had been downloaded and were in the process of installing when I noticed my phone was low batter. I unplugged my laptop and plugged in my phone. We now reach the point of conjecture. I believe at this point, upon noticing I was no longer charging, both TLP and auto-cpufreq kicked in, began fiddling in the background **whilst the kernel was updating**, leading to a system freeze and kernel panic. One held power button later and I reach grub. I select arch linux and am greeted with `Missing vmlinuz from /boot`, and the inability to boot. I hadn't even had my coffee yet.

## Where to begin?
My first thought was to grab a live usb, mount my filesystem and start repairing from there. If you have a live usb, this is almost certainly the easiest was to go about fixing something like this. For a number of unimportant reasons, no usb was at hand, so I had to find another option. The only point of interaction I could find was the grub command line (accessed by pressing `c` at the point of selecting your os). So after searching to see what could be done from here, I discovered to my delight that the answer was *anything*. The grub command line provides you unrestricted access to your entire filesystem. A security concern perhaps, but immensely useful in times of crisis. So, here's the plan, manually boot via the grub command line, then debug why I can't boot.

Typing `ls` will list your different partitions in the form `(hd0,gpt1)`, `(hd0,gpt2)`... I believe if you use older hardrives `gpt` may be replaced with `msdos`. Running `ls (hd0,gptX)/` will show you the filesystem inside that partion. Find which partition contains your system files (`/boot`, `/home`, etc...), for me that was `(hd0,gpt2)`. You can now tell grub that's your root partition via `set root=(hd0,gpt2)`. The next step is finding your boot instructions. `cat /boot/grub/grub.cfg` will print out everything grub does when attempting to boot your system. Look for a line that look like `linux /boot/vmlinuz-linux root=UUID=abcd-1234-...`. The important part here is the `UUID`. In the grub command line type:
`linux /boot/vmlinuz-linux root=UUID=abcd-1234-...` where the `vmlinuz` path leads to a linux distribution inside `/boot`.

Next look for a line that looks like `initrd /initrd.img`. For me that line was `initrd /intel-ucode.img /initramfs-linux.img`. In the command line, run:
`initrd /boot/intel-ucode.img /boot/initramfs-linux.img`
replacing the paths with those in your system.
Finally, run `boot` and cross your fingers and toes. If all goes well you will be back in your system, or at the least in a root terminal with access to your system. From here you can actually start debugging everything you need.

## Now we can start fixing things
The easiest fix for me was just to downgrade my kernel to whatever the previous version was. `ls /var/cache/pacman/pkg/linux-*` shows all cached kernels I had access to. I picked the second newest and ran `pacman -U /var/cache/pacman/pkg/linux-***.pkg.tar.zst`. I did this for both linux and linux-zen. Then running `mkinitcpio -P` and `grub-mkconfig -o /boot/grub/grub.cfg` set everything up allowing me to restart, and boot back into my system. Disabling TLP and running the system upgrade again were the final steps to returning to a normal, working system.
