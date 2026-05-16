import { Router, Request, Response, NextFunction } from 'express';
import { upload } from '../services/cloudinary.service';

const router = Router();

// 🔥 FIXED: Added NextFunction and proper return typing to fix the overload error
router.post('/upload', upload.array('images', 5), (req: Request, res: Response, next: NextFunction): void => {
  try {
    if (!req.files || (req.files as Express.Multer.File[]).length === 0) {
      res.status(400).json({ success: false, message: 'No images provided' });
      return; // Must return to stop execution
    }

    // Get URLs
    const imageUrls = (req.files as Express.Multer.File[]).map(file => file.path);

    res.status(200).json({
      success: true,
      message: 'Images uploaded successfully',
      urls: imageUrls,
    });
  } catch (error) {
    console.error('Upload Error:', error);
    res.status(500).json({ success: false, message: 'Server error during upload' });
  }
});

export default router;