function count = MergeSort(Vec)
    count = mergeSort(Vec, Vec, 1, size(Vec, 2));
end

function [count, Vec, Vec2] = mergeSort(Vec, Vec2, a, b)%// 下标，例如数组int is[5]，全部排序的调用为mergeSort(0,4)
count=0;
if(a<b)
    mid=floor((a+b)/2);
    [c, Vec, Vec2] = mergeSort(Vec, Vec2, a, mid);
    count = count + c;
    [c, Vec, Vec2] = mergeSort(Vec, Vec2, mid+1, b);
    count = count + c;
    [c, Vec, Vec2] = merge(Vec, Vec2, a, mid, b);
    count = count + c;
end
end


function [count, Vec, Vec2] = merge(Vec, Vec2, low, mid, high)
i=low; j=mid+1; k=low;
count=0;
while(i<=mid && j<=high)
    if(Vec(i) <= Vec(j))%// 此处为稳定排序的关键，不能用小于
        Vec2(k)=Vec(i);
        k = k + 1; i = i + 1;
    else
        Vec2(k)=Vec(j);
        k = k + 1; j = j + 1;
        count = count + mid-i+1;%// 每当后段的数组元素提前时，记录提前的距离
    end
end
while(i<=mid)
    Vec2(k) = Vec(i);
    k = k + 1; i = i + 1;
end
while(j<=high)
    Vec2(k)=Vec(j);
    k = k + 1; j = j + 1;
end
for i = low:high %(i=low;i<=high;i++)// 写回原数组
    Vec(i)=Vec2(i);
end
end