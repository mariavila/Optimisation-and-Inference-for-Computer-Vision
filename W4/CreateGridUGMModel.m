function [edgePot,edgeStruct]=CreateGridUGMModel(NumFils, NumCols, K, lambda)
%
%
% NumFils, NumCols: image dimension
% K: number of states
% lambda: smoothing factor
tic

nNodes = NumFils * NumCols;
adj = zeros(nNodes,nNodes);
for i=1:NumFils
    for j=1:NumCols
        p = j*NumFils+i;
        if i~=1
            %Adjacency with north pixel
            p_north = p-1;
            adj(p, p_north)=1;
        end
        if i~=NumFils
            %Adjacency with south pixel
            p_south = p+1;
            adj(p, p_south)=1;
        end
        if j~=1
            %Adjacency with west pixel
            p_west = p-NumFils;
            adj(p, p_west)=1;
        end
        if j~=NumCols
            %Adjacency with east pixel
            p_east = p+NumFils;
            adj(p, p_east)=1;
        end
        
    end
end

edgeStruct = UGM_makeEdgeStruct(adj,K);

%https://www.cs.ubc.ca/~schmidtm/Software/UGM/graphCuts.html
edgePot = zeros(nStates,nStates,edgeStruct.nEdges);
for e = 1:edgeStruct.nEdges
   n1 = edgeStruct.edgeEnds(e,1);
   n2 = edgeStruct.edgeEnds(e,2);

   pot_same = exp(1.8 + 0.3*1/(1+abs(Xstd(n1)-Xstd(n2))));
   edgePot(:,:,e) = [pot_same 1;1 pot_same];
end

toc;