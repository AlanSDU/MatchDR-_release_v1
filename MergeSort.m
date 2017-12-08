function count = MergeSort(Vec)
    count = mergeSort(Vec, Vec, 1, size(Vec, 2));
end

function [count, Vec, Vec2] = mergeSort(Vec, Vec2, a, b)%// �±꣬��������int is[5]��ȫ������ĵ���ΪmergeSort(0,4)
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
    if(Vec(i) <= Vec(j))%// �˴�Ϊ�ȶ�����Ĺؼ���������С��
        Vec2(k)=Vec(i);
        k = k + 1; i = i + 1;
    else
        Vec2(k)=Vec(j);
        k = k + 1; j = j + 1;
        count = count + mid-i+1;%// ÿ����ε�����Ԫ����ǰʱ����¼��ǰ�ľ���
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
for i = low:high %(i=low;i<=high;i++)// д��ԭ����
    Vec(i)=Vec2(i);
end
end