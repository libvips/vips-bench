/* compile with
 
   gcc -g -Wall gegl.c `pkg-config gegl --cflags --libs`

 */

#include <stdio.h>
#include <stdlib.h>

#include <gegl.h>

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
        
  gegl = gegl_node_new ();
        
  load = gegl_node_new_child (gegl,
                              "operation", "gegl:load",
                              "path", argv[1], 
                              NULL);
  printf( "load is node %p\n", load );

  crop = gegl_node_new_child (gegl, 
                              "operation", "gegl:crop",
                              "x", 100.0,
                              "y", 100.0,
                              "width", 4800.0, 
                              "height", 4800.0, 
                              NULL);
  printf( "crop is node %p\n", crop );
                
  scale = gegl_node_new_child (gegl,
                               "operation", "gegl:scale",
                               "x", 0.9,
                               "y", 0.9,
                               "filter", "linear", 
                               "hard-edges", FALSE, 
                               NULL);
  printf( "scale is node %p\n", scale );
                
  sharp = gegl_node_new_child (gegl,
                               "operation", "gegl:unsharp-mask",
                               "std-dev", 1.0, // diameter 7 mask in gegl
                               NULL);
  printf( "sharp is node %p\n", sharp );

  save = gegl_node_new_child (gegl,
                              "operation", "gegl:save",
                              //"operation", "gegl:png-save",
                              //"bitdepth", 8,
                              "path", argv[2], 
                              NULL);
  printf( "save is node %p\n", save );
                
  gegl_node_link_many (load, crop, scale, sharp, save, NULL);
 
  //gegl_node_dump( gegl, 0 );

  gegl_node_process (save);

  //gegl_node_dump( gegl, 0 );
                
  g_object_unref (gegl);

  gegl_exit ();

  return (0);
}
