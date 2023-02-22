function fft_image = sp_fft(image, window)

% Function of taking 2D Fourier transforms of images
% Use a Hamming window by default

if nargin == 1
    window = 'hamming';
end

window_func = str2func(window);

image_window = window_func(length(image));
windowed_data = image.*(image_window*image_window');

fft_image = abs(fft2(windowed_data));
fft_image = fftshift(fft_image);


end