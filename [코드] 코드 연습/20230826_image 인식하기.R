library(magick)
library(image.libfacedetection)

image <- image_read("data/image.jpg")

image

face <- image_detect_faces(image)

face
str(face)
face$detections
face$nr


face

plot(face, image, border = "red", lwd = 5, col = "white")

image2 <- image_read("data/SNSD.jpg")

image2

face2 <- image_detect_faces(image2)

face2

plot(face2, image2, border = "red", lwd = 5, col = "white")


face2


# confidence가 90보다 큰 행만 선택
filtered_detections <- face2$detections[face2$detections$confidence > 90, ]

# r_face 변수에 저장
face2 <- list(nr = nrow(filtered_detections), detections = filtered_detections)

face2
attributes(face2)$class <- "libfacedetection"

face2
plot(face2, image2, border = "red", lwd = 5, col = "white")
