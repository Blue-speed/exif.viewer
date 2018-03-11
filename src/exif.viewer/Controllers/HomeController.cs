using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using SixLabors.ImageSharp;
using Microsoft.AspNetCore.Http;
using exif.viewer.Models;
using System.Diagnostics;

namespace exif.viewer.Controllers
{
    public class HomeController : Controller
    {
        // GET api/values
        public IActionResult  Index()
        {
            return View("Index", new ExifDataModel());
        }

        [HttpPost]
        public IActionResult Index(IFormFile file)
        {
            try {
                var image = Image.Load(file.OpenReadStream());
                return View("Index",new ExifDataModel{ ExifData = image.MetaData.ExifProfile.Values.ToDictionary(m => m.Tag.ToString(), m => m.Value)});
            } catch (Exception ex) {
                return View("Index", new Dictionary<string,string>{ {"error", ex.Message }, {"FileName", file.Name}, {"contentType", file.ContentType}});
            }
        }

        [HttpPost]
        private FileStreamResult Clear(IFormFile file)
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

        public IActionResult Error()
        {
            return View(new ErrorModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
