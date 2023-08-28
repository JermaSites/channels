## The List™️

The List™️ contains most Jerma fan channels that have more than 1 video, to help people keep track of them all!

The list updates once a day (see [how it works](#how-it-works)), if you know any additional channels please [add them](#adding-channel) (or [ask me to](mailto:jake@jakelee.co.uk)). 

*PS: The best-of-the-best have a little Otto 🐶 next to them.*

### YouTube
dynamic-channel-data
#### Standalone Videos / Playlists

* [Jerma985 Deleted Videos Playlist](https://www.youtube.com/playlist?list=PL9haG0G7kUOiKVQ-Iw7LO7fgQUG3xx2L9) - @randomthings2802 (47 Videos)
* [Jerma985 - The ANTI-Streamer](https://www.youtube.com/watch?v=v80fUUqmOgE) - @IC2yt (10m 17s)
* [Jerma985: The Willy Wonka of Twitch](https://www.youtube.com/watch?v=yfUs1H4WptI) - @PedroInfinito (26m 29s)
* [The Greatest Streamer of All Time](https://www.youtube.com/watch?v=LLb0lwvM6mE) - @RubySquigglehead (38m 42s)
* [Subtitled Videos](https://www.youtube.com/playlist?list=PLCK_Hwh3LTgFGDDmVaQTx6mcFE3s0s8nI) & [Subtitled Streams](https://www.youtube.com/playlist?list=PLCK_Hwh3LTgFYX7ZOuZava1s4kKoYdFUm) - @ErasmusMagnusR

### Games

See [Jerma Fan Games](https://jerma-lore.fandom.com/wiki/Jerma_Fan_Games) on the Jerma Lore wiki (yes, this is a real thing), here are the 4 on Steam:

* [Jerma's Big Adventure](https://store.steampowered.com/app/1722570/Jermas_Big_Adventure/)
* [Jerma's Big Adventure 2](https://store.steampowered.com/app/2227100/Jermas_Big_Adventure_2/)
* [Jerma & Otto: The Curse of the Late Streamer](https://store.steampowered.com/app/1669490/Jerma__Otto_The_Curse_of_the_Late_Streamer/)
* [JermaSlots](https://store.steampowered.com/app/1032520/JermaSlots/)

### Tools & More

* [Jerma.org](https://www.jerma.org/): Links to various Jerma-related online things (games, wiki, utilities, social media)
* [Jerma.io](https://jerma.io): A ton of Jerma-y utilities (e.g. this list / quizzes / AI chats / soundboards / chat logs)

## How it works

### Updating

This list updates once per day with the latest stats for each channel. Full details [are available here](https://blog.jakelee.co.uk/fetching-youtube-metadata-in-github-actions-and-persisting/).

### Adding channel

To add a channel, edit [`channels.txt`](https://github.com/JermaSites/channels/blob/main/automation/channels.txt) to include the channel ID, channel name, and a 🐶 if it's a truly impressive channel:
* Channel ID can be retrieved from a profile at `About` -> `Share` -> `Copy channel ID`
* Channel name is not used, except to make the file more readable.

<script>
window.onload = function() {
    // Pull value out of the cell we're comparing
    const getCellValue = (tr, idx) => idx === 0 ? 
        tr.children[idx].textContent : 
        parseFormattedInt(tr.children[idx].textContent);

    // Convert formatted number into sortable numeric one
    function parseFormattedInt(formattedInt) {
        if (formattedInt.includes(".")) {
            return formattedInt
                .replace(".", "")
                .replace("K", "00")
                .replace("M", "00000")
                .replace("B", "00000000");
        } else {
            return formattedInt
                .replace("K", "000")
                .replace("M", "000000")
                .replace("B", "000000000");
        };
    };

    // Compare function for each cell's value
    const comparer = (idx, asc) => (a, b) => ((v1, v2) =>
        v1 !== '' && v2 !== '' && !isNaN(v1) && !isNaN(v2) ? v1 - v2 : v1.toString().localeCompare(v2)
    )(getCellValue(asc ? a : b, idx), getCellValue(asc ? b : a, idx));

    // Make clicking a header sort the contents
    document.querySelectorAll('th').forEach(th => th.addEventListener('click', (() => {
        const table = th.closest('table');
        const tbody = table.querySelector('tbody');
        Array.from(tbody.querySelectorAll('tr'))
            .sort(comparer(Array.from(th.parentNode.children).indexOf(th), this.asc = !this.asc))
            .forEach(tr => tbody.appendChild(tr));
    })));
}
</script>
