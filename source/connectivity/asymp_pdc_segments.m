function c=asymp_pdc_segments(x,ap,pf,nFreqs,metric,alpha,verbose,freqsInterest,subsetChannels)

%Compute connectivity measure given by "option" from series j-->i.
%
%function c=asymp_pdc_segments(x,A,pf,nFreqs,metric,alpha)
%
% input: x - data in segments (m,sz_record,nb_record)
%        A - AR estimate matrix by MVAR
%        pf - covariance matrix provided by MVAR
%        nFreqs - number of point in [0,fs/2] frequency scale
%        metric   euc  - Euclidean ==> original PDC
%                 diag - diagonal ==> gPDC (generalized )
%                 info - informational ==> iPDC
%        alpha = .05 default for distribution
%                if alpha = zero, do not calculate statistics
% output:  c.pdc       - |PDC|^2 estimates
%          c.th        - Threshold value with (1-avalue) significance level.
%          c.ic1,c.ic2 -  confidence interval
%          c.metric    - metric for PDC calculation
%          c.alpha     - significance level
%          c.p         - VAR model order
%          c.patdenr   - 
%          c.patdfr    - 
%function c=asymp_pdc(x,A,pf,nFreqs,metric,alpha)

%Corrected 7/25/2011 to match the frequency range with plotting
%routine, f = 0 was include in the frequency for loop:
%                                for ff = 1:nFreqs,
%                                   f = (ff-1)/(2*nFreqs); % 
%                                        ^?^^

if nargin<6,
   error('ASYMP_PDC requires six input arguments.')
end
[m,n,nb_record] = size(x);
if m > n,
   x=x.';
end;

A = reshape(ap(:,(m+1):end),m,m,[]);

nChannels = m;
p = size(A,3);
computedDeriv = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
np = nb_record*(n-p);
%np = (n-p);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if verbose
fprintf('fazendo matriz Af\n')    
end
Af = A_to_f(A, nFreqs);

% Variables initialization
pdc = zeros(nChannels,nChannels,nFreqs);
%disp('----------------------------------------------------------------------');
if alpha ~= 0,
   th   = zeros(nChannels,nChannels,nFreqs);
   ic1 = zeros(nChannels,nChannels,nFreqs);
   ic2 = zeros(nChannels,nChannels,nFreqs);
   varass1 = zeros(nChannels,nChannels,nFreqs);
   varass2 = zeros(nChannels,nChannels,nFreqs);
   patdfr = zeros(nChannels,nChannels,nFreqs);
   patdenr = zeros(nChannels,nChannels,nFreqs);
%    switch lower(metric)
%       case {'euc'}
%          disp('               Original PDC and asymptotic statistics')
%       case {'diag'}
%          disp('              Generalized PDC and asymptotic statistics')
%       case {'info'}
%          disp('             Informational PDC and asymptotic statistics')
%       otherwise
%          error('Unknown metric.')
%    end;
else
%    switch lower(metric)
%       case {'euc'}
%          disp('                       Original PDC estimation')
%       case {'diag'}
%          disp('                      Generalized PDC estimation')
%       case {'info'}
%          disp('                     Informational PDC estimation')
%       otherwise
%          error('Unknown metric.')
%    end;
end;
%disp('======================================================================');

if verbose
fprintf('fazendo matriz gamma\n')    
end
gamma = bigautocorr_segments(x, p);

if verbose
fprintf('fazendo matrizes omega e omega_evar\n')    
end
omega = kron_alternative(inv(gamma), pf);
omega_evar = 2*pinv(Dup(nChannels))*kron_alternative(pf, pf)*pinv(Dup(nChannels)).';

const1 = norminv(1-(alpha/2));

if verbose
fprintf('entrando no loop\n')    
end
for i = subsetChannels
  for j = subsetChannels

     Iij = fIij(i, j, nChannels);
     Ij = fIj(j, nChannels);
     %No caso diag ou info, deve-se acrescentar o evar na formula'
     switch lower(metric)
        case {'euc'}
           Iije = Iij;
           Ije = Ij;

        case {'diag'}
           evar_d = mdiag(pf);
           evar_d_big = kron_alternative(eye(2*nChannels), evar_d);
           Iije = Iij*pinv(evar_d_big);
           Ije = Ij*pinv(evar_d_big);

        case {'info'}
           evar_d = mdiag(pf);
           evar_d_big = kron_alternative(eye(2*nChannels), evar_d);
           Iije = Iij*pinv(evar_d_big);

           evar_big = kron_alternative(eye(2*nChannels), pf);
           Ije = Ij*pinv(evar_big)*Ij;

        otherwise
           error('Unknown metric.')
     end;
         
     for ff = freqsInterest
         
       if verbose
       fprintf(['loop: i = ' num2str(i) ' j = ' num2str(j) ' f = ' num2str(ff) '\n'])    
       end        
       
       if verbose
       fprintf('calculando Omega2 e L\n')    
       end 
       f = (ff-1)/(2*nFreqs); %Corrected 7/25/2011, f starting at 0
       Ca = fCa(f, p, nChannels);
       omega2 = Ca*omega*Ca';
       L = fChol(omega2);

       a = Af(ff,:,:); a=a(:);    %Equivalent to a = vec(Af[ff, :, :])
       a = [real(a); imag(a)];      %a = cat(a.real, a.imag, 0)

         num = a.'*Iije*a;
         den = a.'*Ije*a;
         pdc(i, j, ff) = num/den;
         % If alpha == 0, do not calculate statistics for faster PDC
         % computation.
         if alpha ~= 0,
            %'Acrescenta derivada em relacao a evar'
            switch lower(metric)
               case {'euc'}
                  dpdc_dev = zeros(1,(nChannels*(nChannels+1))/2);

               case {'diag'}
                  %#todo: tirar partes que nao dependem de f do loop.
                  if ~computedDeriv
                     evar_d = mdiag(pf);
                     evar_d_big = kron_alternative(eye(2*nChannels), evar_d);
                     inv_ed = pinv(evar_d_big);

                     %'derivada de vec(Ed-1) por vecE'
                     de_deh = Dup(nChannels);
                     debig_de = fdebig_de(nChannels);
                     dedinv_dev = diagtom(vec(-inv_ed*inv_ed));
                     dedinv_deh = dedinv_dev*debig_de*de_deh;

                     computedDeriv = 1;
                     
                  end;
                  if verbose
                  fprintf('calculando derivadas\n')    
                  end                  
                  %'derivada do num por vecE'
                  dnum_dev = kron_alternative((Iij*a).', a.')*dedinv_deh;
                  %'derivada do den por vecE'
                  dden_dev = kron_alternative((Ij*a).', a.')*dedinv_deh;

                  dpdc_dev = (den*dnum_dev - num*dden_dev)/(den^2);

               case {'info'}
                  if (i == 1) && (j == 1) && (ff == 1),
                     evar_d = mdiag(pf);
                     evar_d_big = kron_alternative(eye(2*nChannels), evar_d);
                     inv_ed = pinv(evar_d_big);

                     evar_big = kron_alternative(eye(2*nChannels), pf);
                     inv_e = sparse(pinv(evar_big));

                     %'derivada de vec(Ed-1) por vecE'
                     de_deh = Dup(nChannels);
                     debig_de = fdebig_de(nChannels);

                     dedinv_devd = sparse(diagtom(vec(-inv_ed*inv_ed)));
                     dedinv_dehd = sparse(dedinv_devd*debig_de*de_deh);

                     dedinv_dev = sparse(-kron_alternative(inv_e.', inv_e));
                     dedinv_deh = sparse(dedinv_dev*debig_de*de_deh);
                  end;
                  %'derivada do num por vecE'
                  dnum_dev = kron_alternative((Iij*a).', a.')*dedinv_dehd;
                  %'derivada do den por vecE'
                  dden_dev = kron_alternative((Ij*a).', a.'*Ij)*dedinv_deh;
                  dpdc_dev = (den*dnum_dev - num*dden_dev)/(den^2);
               otherwise
                  error('Unknown metric.')
            end;

           if verbose
           fprintf('colocando grandezas na estrutura\n')    
           end            
            G1a = 2*a.'*Iije/den - 2*num*a.'*Ije/(den^2);
            G1 = -G1a*Ca;
            varalpha = G1*omega*G1.';
            varevar = dpdc_dev*omega_evar*dpdc_dev.';
            varass1(i, j, ff) = (varalpha + varevar)/np;

            ic1(i, j, ff) = pdc(i, j, ff) ...
                    - sqrt(varass1(i, j, ff))*const1;
            ic2(i, j, ff) = pdc(i, j, ff) ...
                    + sqrt(varass1(i, j, ff))*const1;

    %             ic1(i, j, ff) = pdc(i, j, ff) - varass1(i, j, ff)*icdf('norm',1-alpha/2.0,0,1);
    %             ic2(i, j, ff) = pdc(i, j, ff) + varass1(i, j, ff)*icdf('norm',1-alpha/2.0,0,1);

            G2a = 2*Iije/den;

            d = fEig(abs(L), G2a); % abs() 19Jan2011

            patdf = (sum(d).^2)./sum(d.^2);
            patden = sum(d)./sum(d.^2);
    %             if i==2 && j==1 && ff == 51,
    %                disp('if i==2 && j==1 && ff == 51,')
    %                patdf
    %                patden
    %                disp('(patden*2*np)')
    %                patden*2*np
    %             end;
            th(i, j, ff) = icdf('chi2',(1-alpha), patdf)/(patden*2*np);
            varass2(i, j, ff) = 2*patdf/(patden*2*np).^2;
            patdfr(i, j, ff) = patdf;
            patdenr(i, j, ff) = patden;
         else % alpha == 0, do not compute asymptotics
            %nop
         end;
     end
  end;
end;

if alpha ~= 0,
   c.pdc=pdc;
   c.th=th;
   c.ic1=ic1;
   c.ic2=ic2;
   c.metric=metric;
   c.alpha=alpha;
   c.p=p;

   c.patden = patdenr;
   c.patdf = patdfr;
   c.varass1 = varass1;
   c.varass2 = varass2;
else
   c.pdc=pdc;
   c.metric=metric;
   c.alpha=0;
   c.p=p;
   c.th=[];
   c.ic1=[];
   c.ic2=[];
   c.patdenr = [];
   c.patdfr = [];
   c.varass1 = [];
   c.varass2 = [];
end;

%==========================================================================
function gamma = bigautocorr_segments(x, p)
%Autocorrelation. Data in rows. From order 0 to p-1.
%Output: nxn blocks of autocorr of lags i. (Nuttall Strand matrix)'''
[m, sz_record, nb_record] = size(x);

gamma = zeros(m*p, m*p);
for i = 1:p
   for j = 1:p
      for r = 1:nb_record
      gamma(((i-1)*m+1):i*m, ((j-1)*m+1):j*m) = gamma(((i-1)*m+1):i*m, ((j-1)*m+1):j*m) + (xlag_segments(x,i-1,r)*(xlag_segments(x,j-1,r).')/sz_record);
      end
      gamma(((i-1)*m+1):i*m, ((j-1)*m+1):j*m) = gamma(((i-1)*m+1):i*m, ((j-1)*m+1):j*m)/nb_record;
   end;
end;

%==========================================================================
function c= xlag_segments(x,tlag,r)
[m,sz_record,nb_record] = size(x);
if tlag == 0
   c = zeros(m,sz_record);
   c = x(:,:,r);
else
   c = zeros(m,sz_record);
   c(:,(tlag+1):end) = x(:,1:(end-tlag),r);
end;

%==========================================================================
function d = fEig(L, G2)
%'''Returns the eigenvalues'''

%L = mat(cholesky(omega, lower=1))
D = L.'*G2*L;
%    d = eigh(D, eigvals_only=True)
%disp('fEig: eig or svd?')
d = svd(D);
d1=sort(d);
%
% the two biggest eigenvalues no matter which values (non negative by
% construction
%
d=d1(length(d)-1:length(d));

if (size(d) > 2),
   disp('more than two Chi-squares in the sum:')
end;

%==========================================================================
function c = fIij(i, j, n)
%'''Returns Iij of the formula'''
Iij = zeros(1,n^2);
Iij(n*(j-1)+i) = 1;
Iij = diag(Iij);
c = kron_alternative(eye(2), Iij);

%==========================================================================
function c=  fIj(j, n)
%'''Returns Ij of the formula'''
Ij = zeros(1,n);
Ij(j) = 1;
Ij = diag(Ij);
Ij = kron_alternative(Ij, eye(n));
c = kron_alternative(eye(2), Ij);

%==========================================================================
function d = fCa(f, p, n)
%'''Returns C* of the formula'''
C1 = cos(-2*pi*f*(1:p));
S1 = sin(-2*pi*f*(1:p));
C2 = [C1; S1];
d = kron_alternative(C2, eye(n^2));

%==========================================================================
function c = fdebig_de(n)
%'''Derivative of kron(I(2n), A) by A'''
%c = kron(TT(2*n, n), eye(n*2*n)) * kron(eye(n), kron(vec(eye(2*n)), eye(n)));
A=sparse(kron_alternative(TT(2*n, n), eye(n*2*n)));
B=sparse(kron_alternative(vec(eye(2*n)), eye(n)));
c = A * kron_alternative(eye(n), B);
c=sparse(c);

%==========================================================================
function c = vec(x)
%vec = lambda x: mat(x.ravel('F')).T
c=x(:);

%==========================================================================
function t = TT(a,b)
%''' TT(a,b)*vec(B) = vec(B.T), where B is (a x b).'''
t = zeros(a*b);
for i = 1:a,
   for j =1:b,
      t((i-1)*b+j, (j-1)*a+i) = 1;
   end;
end;
t = sparse(t);
%==========================================================================
function L = fChol(omega)
% Try Cholesky factorization
try,
   L = chol(omega)';
   % If there's a small negative eigenvalue, diagonalize
catch,
   %   disp('linalgerror, probably IP = 1.')
   [v,d] = eig(omega);
   L = zeros(size(v));
   for i =1:length(d),
      if d(i,i)<0,
         d(i,i)=eps;
      end;
      L(:,i) = v(:,i)*sqrt(d(i,i));
   end;
end;

%==========================================================================
function c = diagtom(a)
a=sparse(a');
c=sparse(diag(a(:)));

%==========================================================================
function c = mdiag(a)
%  diagonal matrix
c=diag(diag(a));

%==========================================================================
function d=Dup(n)
%     '''D*vech(A) = vec(A), with symmetric A'''
d = zeros(n*n, (n*(n+1))/2);
count = 1;
for j=1:n,
   for i =1:n,
      if i >= j,
         d((j-1)*n+i, count)=1;
         count = count+1;
      else
         d((j-1)*n+i,:)=d((i-1)*n+j,:);
      end;
   end;
end;

%==========================================================================

function K = kron_alternative(A,B)
% based on the Matlab's implementation

if ~ismatrix(A) || ~ismatrix(B)
    error(message('MATLAB:kron:TwoDInput'));
end

[ma,na] = size(A);
[mb,nb] = size(B);

if ~issparse(A) && ~issparse(B)

   % Both inputs full, result is full.

   [ia,ib] = meshgrid(1:ma,1:mb);
   [ja,jb] = meshgrid(1:na,1:nb);
   K = A(ia,ja).*B(ib,jb);

else

   % At least one input is sparse, result is sparse.

   [ia,ja,sa] = find(A);
   [ib,jb,sb] = find(B);
   ia = ia(:); ja = ja(:); sa = sa(:);
   ib = ib(:); jb = jb(:); sb = sb(:);
   ka = ones(size(sa));
   kb = ones(size(sb));
   t = mb*(ia-1)';
   ik = t(kb,:)+ib(:,ka);
   t = nb*(ja-1)';
   jk = t(kb,:)+jb(:,ka);
   K = sparse(ik,jk,sb*sa.',ma*mb,na*nb);

end

