module problems;

int arr_part[] = {9,7,4,6,2,8,6,5};
int arr_even[$], arr_odd[$];

int arr_cons[] = {1,1,0,1,1,1,1,0,0,0,1};
int rep_digit, max_rep_digit,count, max_count;

int arr_sec_max[] = {45,34,67,89,78};
int first_max, second_max;

initial begin
    //Array Partition
    for (int i = 0; i < arr_part.size(); i += 1) begin
        if (arr_part[i] % 2) begin
            arr_odd.push_back(arr_part[i]);
        end else begin
            arr_even.push_back(arr_part[i]);
        end
    end

    $display("even array: %p",arr_even);
    $display("odd array: %p",arr_odd);

    //Max Consecutive
    rep_digit = arr_cons[0];
    count = 1; max_count = 0;
    max_rep_digit = arr_cons[0];
    for (int i = 1; i < arr_cons.size(); i+= 1) begin
        if (rep_digit == arr_cons[i]) begin
            count++;
        end else begin
            if (count > max_count) begin
                max_count = count;
                max_rep_digit = rep_digit;
            end
            rep_digit = arr_cons[i];
            count = 1;
        end
    end

    $display("Max consecutive digits in %p is %d and the repeated digit is %d", arr_cons,max_count,max_rep_digit);

    //Second max
    first_max = 0;
    for (int i = 0; i < arr_sec_max.size(); i += 1) begin
        if (arr_sec_max[i] > first_max)
            first_max = arr_sec_max[i];    
    end

    second_max = 0;
    for (int i = 0; i < arr_sec_max.size(); i += 1) begin
        if (arr_sec_max[i] < first_max && arr_sec_max[i] > second_max)
            second_max = arr_sec_max[i];    
    end

    $display("Second max for %p is %d", arr_sec_max,second_max);

end
endmodule