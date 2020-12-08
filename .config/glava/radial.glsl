/* center radius (pixels) */
#define C_RADIUS 155
/* center line thickness (pixels) */
#define C_LINE 0
/* outline color */
#define OUTLINE #333333
/* number of bars (use even values for best results) */
#define NBARS 120
/* width (in pixels) of each bar*/
#define BAR_WIDTH 5.5
/* Amplify magnitude of the results each bar displays */
#define AMPLIFY 120
/* Bar color
#define COLOR mix(#E63535, #FF2727, clamp(d / 1, 0, 1)) */
/* How strong the gradient changes */
#define GRADIENT_POWER 40
/* Bar color changes with height */
#define GRADIENT (d / GRADIENT_POWER + 1)
/* Bar color */
#define COLOR (#695146 * GRADIENT)
/* Angle (in radians) for how much to rotate the visualizer */
#define ROTATE (PI / 2)
/* Whether to swap left/right audio buffers, set to 1 to enable */
#define INVERT 0
/* Aliasing factors. Higher values mean more defined and jagged lines.
   Note: aliasing does not have a notable impact on performance, but requires
   `xroot` transparency to be enabled since it relies on alpha blending with
   the background. */
#define BAR_ALIAS_FACTOR 1.0
#define C_ALIAS_FACTOR 2.8
/* Offset (Y) of the visualization */
#define CENTER_OFFSET_Y 0
/* Offset (X) of the visualization */
#define CENTER_OFFSET_X 0

/* Overrides */
#request setgravitystep 20
#request setsmoothfactor 0.025

/* (DEPRECATED) outline color */
#define BAR_OUTLINE OUTLINE
/* (DEPRECATED) outline width (in pixels, set to 0 to disable outline drawing) */
#define BAR_OUTLINE_WIDTH 0

