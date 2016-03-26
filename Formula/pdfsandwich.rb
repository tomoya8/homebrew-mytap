class Pdfsandwich < Formula
  desc "A generator for sandwich OCR pdfs from scanned pdf files"
  homepage "http://www.tobias-elze.de/pdfsandwich/index.html"
  url "http://downloads.sourceforge.net/project/pdfsandwich/pdfsandwich%200.1.4/pdfsandwich-0.1.4.tar.bz2"
  version "0.1.4"
  sha256 "8b82f3ae08000c5cae1ff5a0f6537b0b563befef928e5198255b743a46714af3"

  depends_on "ocaml" => :build
  depends_on "gawk" => :build
  depends_on "unpaper"
  depends_on "tesseract"

  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

__END__
diff --git a/pdfsandwich.ml b/pdfsandwich.ml
index a446e27..bc44b90 100644
--- a/pdfsandwich.ml
+++ b/pdfsandwich.ml
@@ -18,6 +18,7 @@ let convert = ref "convert";;
 let tesseract = ref "tesseract";;
 let gs = ref "gs";;
 let hocr2pdf = ref "hocr2pdf";;
+let cpdf = ref "cpdf";;
 
 (*global flags:*)
 let verbose = ref false;;
@@ -232,7 +233,8 @@ let process_ocr
 	let pdffilenamelist = List.map snd (Array.to_list tmppdf_arr) in
 	let pdfliststring = String.concat " " pdffilenamelist in
 	pr ("OCR done. Writing \"" ^ outfile ^ "\"");
-	run (!gs ^ " -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\"" ^ outfile ^ "\" " ^ pdfliststring);
+	(* run (!gs ^ " -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=\"" ^ outfile ^ "\" " ^ pdfliststring); *)
+	run (!cpdf ^ " -o \"" ^ outfile ^ "\" " ^ pdfliststring);
 	if (not debug) then List.iter Sys.remove pdffilenamelist;
 ;;
 
