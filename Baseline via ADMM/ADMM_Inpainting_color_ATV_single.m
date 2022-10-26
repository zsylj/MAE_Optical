function [PSNR, SSIM, PSNR0, SSIM0, u, out_img] = ADMM_Inpainting_color_ATV_single(img,img_masked,mask,rho,tau,tol,max_iter)
%y: measurement (vector)
%Phi: linear transformation (matrix)
%x: ground truth (vector)
%D: Penaltly (matrix)
%x = argmin_x 1/2 ||Phi*x-y||_2^2 + tau.*|D*u|_1
%Notice: * is matrix multiplication

[img_h, img_w, img_c] = size(img_masked);
N=img_h*img_w;

y=reshape(img_masked,[N*img_c,1]);

[D_c, Dt_c, DtD_c] = DiffOper(img_h, img_w, img_c);
[~, Phit_c, PhitPhi_c] = MtxOper(mask);

w=zeros(2*img_c*N,1);
u=zeros(2*img_c*N,1);

x=zeros(img_c*N,1);%or x=y anyway just init

err=100;%anyway just init>tol

k=1;%init

while err>tol && k<=max_iter
    %fprintf('iter. %g ',k);
    x_prev = x;%init
    
    x = (PhitPhi_c+rho.*DtD_c)\(Phit_c*y+rho.*Dt_c*w-Dt_c*u);%step1
    %[x,~] = cgs(PhitPhi_c+rho.*DtD_c, Phit_c*y+rho.*Dt_c*w-Dt_c*u,1e-5,100);%step1
    fprintf('%3g',k)

    err = norm(x_prev-x)/norm(x);
    %fprintf('err=%g \n',err);

    out_img = reshape(x,[img_h, img_w, img_c]);
    imshow(out_img)

    [PSNR0, SSIM0] = standar(img_masked, img);
    [PSNR, SSIM] = standar(out_img, img);

    %Soft Threshold
    w = sign(D_c*x+u./rho).*max((abs(D_c*x)-tau./rho),0);

    %u update
    u = u + rho.*(D_c*x-w);

    k=k+1;

end

fprintf("\n")

if k>max_iter
    fprintf('Abort, Err= %g \t',err);
    fprintf('Iter = %g \n', k)
else
    fprintf('Err= %g \t',err);
    fprintf('Iter = %g \n', k)
end

end

function [D_c, Dt_c, DtD_c] = DiffOper(img_h, img_w, img_c)%c stand for color
N=img_h*img_w;
D_v_c = spdiags([-ones(img_c*N,1), ones(img_c*N,1)], [0, 1], img_c*N, img_c*N);%vertical diff mtx (fwd)
D_h_c = spdiags([-ones(img_c*N,1), ones(img_c*N,1)], [0, img_h], img_c*N, img_c*N);%horizontal diff mtx (fwd)
D_c = [D_v_c; D_h_c];
Dt_c = D_c';
DtD_c = Dt_c * D_c;
end

function [Phi_c, Phit_c, PhitPhi_c] = MtxOper(mask)
[mask_h, mask_w, mask_c] = size(mask);
N=mask_h*mask_w;
mask_v=reshape(mask(:,:,:),[mask_c*N,1]);
Phi_c=spdiags([mask_v], 0, mask_c*N, mask_c*N);
Phit_c = Phi_c';
PhitPhi_c = Phit_c * Phi_c;
end

function [PSNR, SSIM] = standar(out, ref)
PSNR = psnr(out, ref);
SSIM = ssim(out, ref);
end