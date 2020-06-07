function Fire_value = DTNP(C,N)
% C: input image 
% N: iteration number
Theta = 1;               
[m,n] = size(C);
Theta = Theta.*ones(m,n);
Fire_value = zeros(m,n);
U = zeros(m,n);
p = zeros(m,n);
link_arrange = 3;
center_x=round(link_arrange/2);
center_y=round(link_arrange/2);
W=zeros(link_arrange,link_arrange);
for i=1:link_arrange
    for j=1:link_arrange
        if (i==center_x)&&(j==center_y)
            W(i,j)=0;
        else
            W(i,j)=1./sqrt((i-center_x).^2+(j-center_y).^2); % convolve kernel
        end
    end
end

for t=1:N
    work = conv2(p,W,'same');
    for row=1:m
        for col=1:n
            if p(row,col) == 0   
                U(row,col) = U(row,col) + C(row,col) + work(row,col);
                Theta(row,col) = Theta(row,col);
            else
                U(row,col) = C(row,col) + work(row,col); 
                Theta(row,col) = Theta(row,col)  - 1  +  p(row,col);       
            end
        end
    end
    for i =1:m
        for j= 1:n
            if U(i,j) >= Theta(i,j)
                p(i,j) = 1.1;
            else
                p(i,j) = 0;
                
            end
        end
    end
    p = double(p);
    Fire_value = Fire_value + p;
end
end

