/* compile with
 
   gcc -g -Wall gegl.c `pkg-config gegl-0.3 --cflags --libs`

 */

#include <stdio.h>
#include <stdlib.h>

#include <gegl.h>

static void 
null_log_handler (const gchar *log_domain, 
		  GLogLevelFlags log_level, 
		  const gchar *message, 
		  gpointer user_data)
{
}

int
main (int argc, char **argv)
{
  GeglNode *gegl, *load, *crop, *scale, *sharp, *save;

  gegl_init (&argc, &argv);

  if (argc != 3) 
    {           
      fprintf (stderr, "usage: %s file-in file-out\n", argv[0]);
      exit (1);
    }

  g_log_set_handler ("GEGL-load.c", 
    G_LOG_LEVEL_WARNING | G_LOG_FLAG_FATAL | G_LOG_FLAG_RECURSION, 
    null_log_handler, NULL);
  g_log_set_handler ("GEGL-gegl-tile-handler-cache.c", 
    G_LOG_LEVEL_WARNING | G_LOG_FLAG_FATAL | G_LOG_FLAG_RECURSION, 
    null_log_handler, NULL);

  gegl = gegl_node_new ();
        
  load = gegl_node_new_child (gegl,
                              "operation", "gegl:load",
                              "path", argv[1], 
                              NULL);

  crop = gegl_node_new_child (gegl, 
                              "operation", "gegl:crop",
                              "x", 100.0,
                              "y", 100.0,
                              "width", 4800.0, 
                              "height", 4800.0, 
                              NULL);
                
  scale = gegl_node_new_child (gegl,
                               "operation", "gegl:scale-ratio",
                               "x", 0.9,
                               "y", 0.9,
                               "sampler", GEGL_SAMPLER_LINEAR,
                               NULL);

  sharp = gegl_node_new_child (gegl,
                               "operation", "gegl:unsharp-mask",
                               "std-dev", 1.0, // diameter 7 mask in gegl
                               NULL);

  /*
  sharp = gegl_node_new_child (gegl,
                               "operation", "gegl:convolution-matrix",
                               "a1", -1.0,
                               "b1", -1.0,
                               "c1", -1.0,
                               "d1", 0.0,
                               "e1", 0.0,
                               "a2", -1.0,
                               "b2", 16.0,
                               "c2", -1.0,
                               "d2", 0.0,
                               "e2", 0.0,
                               "a3", -1.0,
                               "b3", -1.0,
                               "c3", -1.0,
                               "d3", 0.0,
                               "e3", 0.0,
                               "a4", 0.0,
                               "b4", 0.0,
                               "c4", 0.0,
                               "d4", 0.0,
                               "e4", 0.0,
                               "a5", 0.0,
                               "b5", 0.0,
                               "c5", 0.0,
                               "d5", 0.0,
                               "e5", 0.0,
                               "divisor", 8.0,
                               NULL);
   */

  save = gegl_node_new_child (gegl,
                              "operation", "gegl:save",
                              //"operation", "gegl:png-save",
                              //"bitdepth", 8,
                              "path", argv[2], 
                              NULL);

  gegl_node_link_many (load, crop, scale, sharp, save, NULL);
 
  //gegl_node_dump( gegl, 0 );

  gegl_node_process (save);

  //gegl_node_dump( gegl, 0 );
                
  g_object_unref (gegl);

  gegl_exit ();

  return (0);
}
