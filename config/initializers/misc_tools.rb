def scale_image w, h, scaler=0.5
  w *= scaler
  h *= scaler
  puts "
    \n
    width: #{w}, height: #{h}, scaled by #{scaler}
    \n
  "
end
