function arr = swap(arr, ind1, ind2)
    val1 = arr(ind1);
    val2 = arr(ind2);
    arr(ind1) = val2;
    arr(ind2) = val1;
end