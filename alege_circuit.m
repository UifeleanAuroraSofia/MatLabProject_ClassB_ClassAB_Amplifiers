function alege_circuit(tipCircuit, R_AB_text, R_AB_value, Id_text, Id_value, x, y, Po_text, Po_value, PT_text, PT_value, Pd_text, Pd_value, PR_text, PR_value)
    if (tipCircuit == 2)
        set(R_AB_text, 'Visible', 'on');
        set(R_AB_value, 'Visible', 'on');
        set(Id_text, 'Visible', 'on');
        set(Id_value, 'Visible', 'on');
        set(Pd_text, 'Visible', 'on');
        set(Pd_value, 'Visible', 'on');
        set(PR_text, 'Visible', 'on');
        set(PR_value, 'Visible', 'on');
        I2=imresize(y, [2 2]);
        imagesc(y);
        set(gca,'units','normalized','position',[0.02 0.05 0.25 0.3]);
        set(gca,'XTick',[], 'YTick', [])
    else
        set(R_AB_text, 'Visible', 'off');
        set(R_AB_value, 'Visible', 'off');
        set(Id_text, 'Visible', 'off');
        set(Id_value, 'Visible', 'off');
        set(Pd_text, 'Visible', 'off');
        set(Pd_value, 'Visible', 'off');
        set(PR_text, 'Visible', 'off');
        set(PR_value, 'Visible', 'off');
        I2=imresize(x, [2 2]);
        imagesc(x);
        set(gca,'units','normalized','position',[0.02 0.05 0.25 0.3]);
        set(gca,'XTick',[], 'YTick', [])
    end
end