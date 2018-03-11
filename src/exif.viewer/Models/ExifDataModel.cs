using System;
using System.Collections.Generic;
using System.Linq;

namespace exif.viewer.Models
{
    public class ExifDataModel 
    {
        public IDictionary<string,object> ExifData { get; set; }
        public bool HasData => ExifData?.Any() ?? false;
    }
}