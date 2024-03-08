function [contourCell] = fftContour(image) 
    Xfft = fftshift(fft2(image)); % 2d fft
    Xphi = imag(log(Xfft));
    Xphiinv = abs(ifft2(exp(1i*Xphi)));    
    Q = (imdilate(image, ones(3, 3)) - imerode(image, ones(3, 3)));
    contourCell = Q.*(Xphiinv > max(Xphiinv(:))/4);
end
