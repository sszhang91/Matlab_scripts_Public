function cmap=skycmap(n,varargin)

p=inputParser;
p.addParamValue('gamma',1.8, @(x)x>0);
p.addParamValue('minColor','none');
p.addParamValue('maxColor','none');
p.addParamValue('invert',0, @(x)x==0 || x==1);

if nargin==1
    p.addRequired('n', @(x)x>0 && mod(x,1)==0);
    p.parse(n);
elseif nargin>1
    p.addRequired('n', @(x)x>0 && mod(x,1)==0);
    p.parse(n, varargin{:});
else
    p.addParamValue('n',256, @(x)x>0 && mod(x,1)==0);
    p.parse();
end
config = p.Results;
n=config.n;

%the ControlPoints and the spacing between them

%the ControlPoints in a bit more colorful variant -> slightly less
%isoluminescence, but gives a more vivid look
cP(:,1) = [30  60  150]./255; k(1)=1;  %cyan at index 1
cP(:,2) = [180 90  155]./255; k(2)=13; %purple at index 17
cP(:,3) = [230 85  65 ]./255; k(3)=26; %redish at index 32
cP(:,4) = [220 220 0  ]./255; k(4)=38; %yellow at index 64
cP(:,5) = [220 220 0  ]./255; k(5)=51; %yellow at index 64
cP(:,6) = [220 220 0  ]./255; k(6)=64; %yellow at index 64

for i=1:5
    f{i}   = linspace(0,1,(k(i+1)-k(i)+1))';  % linear space between these controlpoints
    ind{i} = linspace(k(i),k(i+1),(k(i+1)-k(i)+1))';
end
cmap = interp1((1:6),cP',linspace(1,6,64)); % for non-iso points, a normal interpolation gives better results


% normal linear interpolation to achieve the required number of points for the colormap
cmap = abs(interp1(linspace(0,1,size(cmap,1)),cmap,linspace(0,1,n)));

if config.invert
    cmap = flipud(cmap);
end

if ischar(config.minColor)
    if ~strcmp(config.minColor,'none')
        switch config.minColor
            case 'white'
                cmap(1,:) = [1 1 1];
            case 'black'
                cmap(1,:) = [0 0 0];
            case 'lightgray'
                cmap(1,:) = [0.8 0.8 0.8];
            case 'darkgray'
                cmap(1,:) = [0.2 0.2 0.2];
        end
    end
else
    cmap(1,:) = config.minColor;
end
if ischar(config.maxColor)
    if ~strcmp(config.maxColor,'none')
        switch config.maxColor
            case 'white'
                cmap(end,:) = [1 1 1];
            case 'black'
                cmap(end,:) = [0 0 0];
            case 'lightgray'
                cmap(end,:) = [0.8 0.8 0.8];
            case 'darkgray'
                cmap(end,:) = [0.2 0.2 0.2];
        end
    end
else
    cmap(end,:) = config.maxColor;
end
