function maxDiffCol = findMaxDiffColumn(matrix)  
    
    numCols = size(matrix, 2);  
      
    maxDiff = 0;  
      
    for col = 1:numCols  
        colVec = matrix(:, col);  
        colMax = max(colVec);  
        colMin = min(colVec);  
        diff = colMax - colMin;   
        if diff > maxDiff  
            maxDiff = diff;  
            maxDiffCol = col;  
        end  
    end  
end