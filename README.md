# Digital Kaleidoscope

[![Digital Kaleidoscope Demo](https://markdown-videos-api.jorgenkh.no/url?url=https%3A%2F%2Fyoutu.be%2FbtHL5g2rdYg)](https://youtu.be/btHL5g2rdYg)

### Description

Digital Kaleidoscope is a visually mesmerizing project developed using the LOVE2D framework in Lua. It started as a quick experiment, intended as a trial to explore the capabilities of LOVE2D and determine if it would be the right direction for a final project. What began as a simple concept turned into a complex and captivating manual music visualizer.

### Project Evolution

The project's journey began with the idea of creating a manually controlled line that bounces off the walls of the application window to form geometric patterns. As I delved into LOVE2D, I encountered several challenges with Lua and computer graphics but was inspired by LOVE's easy joystick support. With the help of an Xbox controller, I could intuitively move a dot around the screen with edge detection to prevent it from disappearing.

The initial challenge was implementing line reflections off the screen edges. It involved a deeper understanding of trigonometry, and I used a ray optics simulator to visualize the problem. The breakthrough came when I rediscovered the "soh cah toa" mnemonic and solved the problem. This marked a turning point, as the seemingly simple concept became a complex mathematical solution.

As the project progressed, I developed recursive functions to create multiple reflections and overcame challenges with Lua, including working with tables and global variables. The prototype was taking shape, and new features were added, driven by my interaction with the project.

### Challenges and Solutions

One significant challenge was dealing with the complexity of geometric patterns, which led to occasional visual artifacts. After meticulous testing, it was concluded that LOVE's framework might have memory limitations affecting the drawing operations. This issue was resolved by drawing each line separately, even though it required modifying the reflection algorithm.

Scaling cursor speed, color modulation, and adding new controller mappings were other significant tasks, each revealing unique insights into mathematical relationships and order of execution. The project evolved to incorporate more visual modes, such as polygons, and abstract effects using stencil functionality.

### Features

- Manual music visualizer with joystick support.
- Dynamic line reflections and geometric patterns.
- Color modulation and controller mappings.
- Polygon and stencil visual modes.
- Potential for future enhancements: audio responsiveness, pause menu, opening menu, control scheme diagram, and tutorials.

### Conclusion

Digital Kaleidoscope is not just a technical experiment but a visually engaging and playful project that combines music, art, and mathematics. While it may have pushed the boundaries of the LOVE2D framework and Lua, it has been a rewarding journey.

For further details, check out the [Extended Project Description](ExtendedProjDescription.md)!

For any inquiries or collaboration opportunities, feel free to contact me.
