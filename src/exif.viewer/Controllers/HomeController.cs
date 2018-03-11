using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using SixLabors.ImageSharp;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Net.Http.Headers;

namespace exif.viewer.Controllers
{
    [Route("Home")]
    public class HomeController : Controller
    {
        // GET api/values
        [HttpGet("Index")]
        public ActionResult Get()
        {
            return View("Index");
        }

        [HttpPost("Index")]
        public Dictionary<string,object> Post(IFormFile file)
        {
            
            var image = Image.Load(file.OpenReadStream());
            return image.MetaData.ExifProfile.Values.ToDictionary(m => m.Tag.ToString(), m => m.Value);
        }

        [HttpPost("Clear")]
        private FileStreamResult CleanImage(IFormFile file)
        {
            var image = Image.Load(file.OpenReadStream());
            image.MetaData.Properties.Clear();
            image.MetaData.ExifProfile = new SixLabors.ImageSharp.MetaData.Profiles.Exif.ExifProfile();
            using(Stream stream = new MemoryStream()){
                var imageFormat = ImageFormats.Png;
                image.Save(stream, imageFormat);
                return File(stream, ImageFormats.Png.DefaultMimeType);
            }
        }
    }
}
