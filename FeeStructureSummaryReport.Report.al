#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51794 "Fee Structure Summary Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fee Structure Summary Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            RequestFilterFields = "Settlement Type Filter";
            column(ReportForNavId_1; 1)
            {
            }
            column(Pics;compInf.Picture)
            {
            }
            column(ProgName;"ACA-Programme".Description)
            {
            }
            column(FacultyName;"ACA-Programme".Faculty)
            {
            }
            column(Y1;Y1)
            {
            }
            column(Y2;Y2)
            {
            }
            column(Y3;Y3)
            {
            }
            column(Y4;Y4)
            {
            }
            column(Y5;Y5)
            {
            }
            column(Y1_ItemLabel;Y1_ItemLabel)
            {
            }
            column(Y1S1_Tuit_Caption;Y1S1_Tuit_Caption)
            {
            }
            column(Y1S2_Tuit_Caption;Y1S2_Tuit_Caption)
            {
            }
            column(Y1_Tuit_Total_Caption;Y1_Tuit_Total_Caption)
            {
            }
            column(Y1S1_Tuit_Caption2;Y1S1_Tuit_Caption2)
            {
            }
            column(Y1S2_Tuit_Caption2;Y1S2_Tuit_Caption2)
            {
            }
            column(Y1_Tuit_Total_Caption2;Y1_Tuit_Total_Caption2)
            {
            }
            column(Y1S1_Tuit_Caption3;Y1S1_Tuit_Caption3)
            {
            }
            column(Y1S2_Tuit_Caption3;Y1S2_Tuit_Caption3)
            {
            }
            column(Y1_Tuit_Total_Caption3;Y1_Tuit_Total_Caption3)
            {
            }
            column(Y1S1_Tuit_Val;Y1S1_Tuit_Val)
            {
            }
            column(Y1S2_Tuit_Val;Y1S2_Tuit_Val)
            {
            }
            column(Y1_Tuit_Total_Val;Y1_Tuit_Total_Val)
            {
            }
            column(Y1_Tuit_txt_lbl1;Y1_Tuit_txt_lbl1)
            {
            }
            column(Y1_Charges_txt_lbl2;Y1_Charges_txt_lbl2)
            {
            }
            column(Y1_Tuit_txt;Y1_Tuit_txt)
            {
            }
            column(Y1_Tuit_txt2;Y1_Tuit_txt2)
            {
            }
            column(Y1_Charges_txt;Y1_Charges_txt)
            {
            }
            column(Y1_Charges_txt2;Y1_Charges_txt2)
            {
            }
            column(Y1_Trans_txt_Footer;Y1_Trans_txt_Footer)
            {
            }
            column(Y1S1_Total;Y1S1_Total)
            {
            }
            column(Y1S2_Total;Y1S2_Total)
            {
            }
            column(Y1_Grand_Total;Y1_Grand_Total)
            {
            }
            column(Y1_Trans_Txt1;Y1_Trans_Txt[1])
            {
            }
            column(Y1S1_Trans_Val1;Y1S1_Trans_Val[1])
            {
            }
            column(Y1S2_Trans_Val1;Y1S2_Trans_Val[1])
            {
            }
            column(Y1_Trans_Grand_Total1;Y1_Trans_Grand_Total[1])
            {
            }
            column(Y1_Trans_Code1;Y1_Trans_Code[1])
            {
            }
            column(Y1_Trans_Txt2;Y1_Trans_Txt[2])
            {
            }
            column(Y1S1_Trans_Val2;Y1S1_Trans_Val[2])
            {
            }
            column(Y1S2_Trans_Val2;Y1S2_Trans_Val[2])
            {
            }
            column(Y1_Trans_Grand_Total2;Y1_Trans_Grand_Total[2])
            {
            }
            column(Y1_Trans_Code2;Y1_Trans_Code[2])
            {
            }
            column(Y1_Trans_Txt3;Y1_Trans_Txt[3])
            {
            }
            column(Y1S1_Trans_Val3;Y1S1_Trans_Val[3])
            {
            }
            column(Y1S2_Trans_Val3;Y1S2_Trans_Val[3])
            {
            }
            column(Y1_Trans_Grand_Total3;Y1_Trans_Grand_Total[3])
            {
            }
            column(Y1_Trans_Code3;Y1_Trans_Code[3])
            {
            }
            column(Y1_Trans_Txt4;Y1_Trans_Txt[4])
            {
            }
            column(Y1S1_Trans_Val4;Y1S1_Trans_Val[4])
            {
            }
            column(Y1S2_Trans_Val4;Y1S2_Trans_Val[4])
            {
            }
            column(Y1_Trans_Grand_Total4;Y1_Trans_Grand_Total[4])
            {
            }
            column(Y1_Trans_Code4;Y1_Trans_Code[4])
            {
            }
            column(Y1_Trans_Txt5;Y1_Trans_Txt[5])
            {
            }
            column(Y1S1_Trans_Val5;Y1S1_Trans_Val[5])
            {
            }
            column(Y1S2_Trans_Val5;Y1S2_Trans_Val[5])
            {
            }
            column(Y1_Trans_Grand_Total5;Y1_Trans_Grand_Total[5])
            {
            }
            column(Y1_Trans_Code5;Y1_Trans_Code[5])
            {
            }
            column(Y1_Trans_Txt6;Y1_Trans_Txt[6])
            {
            }
            column(Y1S1_Trans_Val6;Y1S1_Trans_Val[6])
            {
            }
            column(Y1S2_Trans_Val6;Y1S2_Trans_Val[6])
            {
            }
            column(Y1_Trans_Grand_Total6;Y1_Trans_Grand_Total[6])
            {
            }
            column(Y1_Trans_Code6;Y1_Trans_Code[6])
            {
            }
            column(Y1_Trans_Txt7;Y1_Trans_Txt[7])
            {
            }
            column(Y1S1_Trans_Val7;Y1S1_Trans_Val[7])
            {
            }
            column(Y1S2_Trans_Val7;Y1S2_Trans_Val[7])
            {
            }
            column(Y1_Trans_Grand_Total7;Y1_Trans_Grand_Total[7])
            {
            }
            column(Y1_Trans_Code7;Y1_Trans_Code[7])
            {
            }
            column(Y1_Trans_Txt8;Y1_Trans_Txt[8])
            {
            }
            column(Y1S1_Trans_Val8;Y1S1_Trans_Val[8])
            {
            }
            column(Y1S2_Trans_Val8;Y1S2_Trans_Val[8])
            {
            }
            column(Y1_Trans_Grand_Total8;Y1_Trans_Grand_Total[8])
            {
            }
            column(Y1_Trans_Code8;Y1_Trans_Code[8])
            {
            }
            column(Y1_Trans_Txt9;Y1_Trans_Txt[9])
            {
            }
            column(Y1S1_Trans_Val9;Y1S1_Trans_Val[9])
            {
            }
            column(Y1S2_Trans_Val9;Y1S2_Trans_Val[9])
            {
            }
            column(Y1_Trans_Grand_Total9;Y1_Trans_Grand_Total[9])
            {
            }
            column(Y1_Trans_Code9;Y1_Trans_Code[9])
            {
            }
            column(Y1_Trans_Txt10;Y1_Trans_Txt[10])
            {
            }
            column(Y1S1_Trans_Val10;Y1S1_Trans_Val[10])
            {
            }
            column(Y1S2_Trans_Val10;Y1S2_Trans_Val[10])
            {
            }
            column(Y1_Trans_Grand_Total10;Y1_Trans_Grand_Total[10])
            {
            }
            column(Y1_Trans_Code10;Y1_Trans_Code[10])
            {
            }
            column(Y1_Trans_Txt11;Y1_Trans_Txt[11])
            {
            }
            column(Y1S1_Trans_Val11;Y1S1_Trans_Val[11])
            {
            }
            column(Y1S2_Trans_Val11;Y1S2_Trans_Val[11])
            {
            }
            column(Y1_Trans_Grand_Total11;Y1_Trans_Grand_Total[11])
            {
            }
            column(Y1_Trans_Code11;Y1_Trans_Code[11])
            {
            }
            column(Y1_Trans_Txt12;Y1_Trans_Txt[12])
            {
            }
            column(Y1S1_Trans_Val12;Y1S1_Trans_Val[12])
            {
            }
            column(Y1S2_Trans_Val12;Y1S2_Trans_Val[12])
            {
            }
            column(Y1_Trans_Grand_Total12;Y1_Trans_Grand_Total[12])
            {
            }
            column(Y1_Trans_Code12;Y1_Trans_Code[12])
            {
            }
            column(Y1_Trans_Txt13;Y1_Trans_Txt[13])
            {
            }
            column(Y1S1_Trans_Val13;Y1S1_Trans_Val[13])
            {
            }
            column(Y1S2_Trans_Val13;Y1S2_Trans_Val[13])
            {
            }
            column(Y1_Trans_Grand_Total13;Y1_Trans_Grand_Total[13])
            {
            }
            column(Y1_Trans_Code13;Y1_Trans_Code[13])
            {
            }
            column(Y1_Trans_Txt14;Y1_Trans_Txt[14])
            {
            }
            column(Y1S1_Trans_Val14;Y1S1_Trans_Val[14])
            {
            }
            column(Y1S2_Trans_Val14;Y1S2_Trans_Val[14])
            {
            }
            column(Y1_Trans_Grand_Total14;Y1_Trans_Grand_Total[14])
            {
            }
            column(Y1_Trans_Code14;Y1_Trans_Code[14])
            {
            }
            column(Y1_Trans_Txt15;Y1_Trans_Txt[15])
            {
            }
            column(Y1S1_Trans_Val15;Y1S1_Trans_Val[15])
            {
            }
            column(Y1S2_Trans_Val15;Y1S2_Trans_Val[15])
            {
            }
            column(Y1_Trans_Grand_Total15;Y1_Trans_Grand_Total[15])
            {
            }
            column(Y1_Trans_Code15;Y1_Trans_Code[15])
            {
            }
            column(Y1_Trans_Txt16;Y1_Trans_Txt[16])
            {
            }
            column(Y1S1_Trans_Val16;Y1S1_Trans_Val[16])
            {
            }
            column(Y1S2_Trans_Val16;Y1S2_Trans_Val[16])
            {
            }
            column(Y1_Trans_Grand_Total16;Y1_Trans_Grand_Total[16])
            {
            }
            column(Y1_Trans_Code16;Y1_Trans_Code[16])
            {
            }
            column(counts;counts)
            {
            }
            column(Settlement_Type;Settlement_Type+' FEE STRUCTURE')
            {
            }
            column(i1;i1)
            {
            }
            column(Y2_ItemLabel;Y2_ItemLabel)
            {
            }
            column(Y2S1_Tuit_Caption;Y2S1_Tuit_Caption)
            {
            }
            column(Y2S2_Tuit_Caption;Y2S2_Tuit_Caption)
            {
            }
            column(Y2_Tuit_Total_Caption;Y2_Tuit_Total_Caption)
            {
            }
            column(Y2S1_Tuit_Caption2;Y2S1_Tuit_Caption2)
            {
            }
            column(Y2S2_Tuit_Caption2;Y2S2_Tuit_Caption2)
            {
            }
            column(Y2_Tuit_Total_Caption2;Y2_Tuit_Total_Caption2)
            {
            }
            column(Y2S1_Tuit_Caption3;Y2S1_Tuit_Caption3)
            {
            }
            column(Y2S2_Tuit_Caption3;Y2S2_Tuit_Caption3)
            {
            }
            column(Y2_Tuit_Total_Caption3;Y2_Tuit_Total_Caption3)
            {
            }
            column(Y2S1_Tuit_Val;Y2S1_Tuit_Val)
            {
            }
            column(Y2S2_Tuit_Val;Y2S2_Tuit_Val)
            {
            }
            column(Y2_Tuit_Total_Val;Y2_Tuit_Total_Val)
            {
            }
            column(Y2_Tuit_txt_lbl1;Y2_Tuit_txt_lbl1)
            {
            }
            column(Y2_Charges_txt_lbl2;Y2_Charges_txt_lbl2)
            {
            }
            column(Y2_Tuit_txt;Y2_Tuit_txt)
            {
            }
            column(Y2_Tuit_txt2;Y2_Tuit_txt2)
            {
            }
            column(Y2_Charges_txt;Y2_Charges_txt)
            {
            }
            column(Y2_Charges_txt2;Y2_Charges_txt2)
            {
            }
            column(Y2_Trans_txt_Footer;Y2_Trans_txt_Footer)
            {
            }
            column(Y2S1_Total;Y2S1_Total)
            {
            }
            column(Y2S2_Total;Y2S2_Total)
            {
            }
            column(Y2_Grand_Total;Y2_Grand_Total)
            {
            }
            column(Y2_Trans_Txt1;Y2_Trans_Txt[1])
            {
            }
            column(Y2S1_Trans_Val1;Y2S1_Trans_Val[1])
            {
            }
            column(Y2S2_Trans_Val1;Y2S2_Trans_Val[1])
            {
            }
            column(Y2_Trans_Grand_Total1;Y2_Trans_Grand_Total[1])
            {
            }
            column(Y2_Trans_Code1;Y2_Trans_Code[1])
            {
            }
            column(Y2_Trans_Txt2;Y2_Trans_Txt[2])
            {
            }
            column(Y2S1_Trans_Val2;Y2S1_Trans_Val[2])
            {
            }
            column(Y2S2_Trans_Val2;Y2S2_Trans_Val[2])
            {
            }
            column(Y2_Trans_Grand_Total2;Y2_Trans_Grand_Total[2])
            {
            }
            column(Y2_Trans_Code2;Y2_Trans_Code[2])
            {
            }
            column(Y2_Trans_Txt3;Y2_Trans_Txt[3])
            {
            }
            column(Y2S1_Trans_Val3;Y2S1_Trans_Val[3])
            {
            }
            column(Y2S2_Trans_Val3;Y2S2_Trans_Val[3])
            {
            }
            column(Y2_Trans_Grand_Total3;Y2_Trans_Grand_Total[3])
            {
            }
            column(Y2_Trans_Code3;Y2_Trans_Code[3])
            {
            }
            column(Y2_Trans_Txt4;Y2_Trans_Txt[4])
            {
            }
            column(Y2S1_Trans_Val4;Y2S1_Trans_Val[4])
            {
            }
            column(Y2S2_Trans_Val4;Y2S2_Trans_Val[4])
            {
            }
            column(Y2_Trans_Grand_Total4;Y2_Trans_Grand_Total[4])
            {
            }
            column(Y2_Trans_Code4;Y2_Trans_Code[4])
            {
            }
            column(Y2_Trans_Txt5;Y2_Trans_Txt[5])
            {
            }
            column(Y2S1_Trans_Val5;Y2S1_Trans_Val[5])
            {
            }
            column(Y2S2_Trans_Val5;Y2S2_Trans_Val[5])
            {
            }
            column(Y2_Trans_Grand_Total5;Y2_Trans_Grand_Total[5])
            {
            }
            column(Y2_Trans_Code5;Y2_Trans_Code[5])
            {
            }
            column(Y2_Trans_Txt6;Y2_Trans_Txt[6])
            {
            }
            column(Y2S1_Trans_Val6;Y2S1_Trans_Val[6])
            {
            }
            column(Y2S2_Trans_Val6;Y2S2_Trans_Val[6])
            {
            }
            column(Y2_Trans_Grand_Total6;Y2_Trans_Grand_Total[6])
            {
            }
            column(Y2_Trans_Code6;Y2_Trans_Code[6])
            {
            }
            column(Y2_Trans_Txt7;Y2_Trans_Txt[7])
            {
            }
            column(Y2S1_Trans_Val7;Y2S1_Trans_Val[7])
            {
            }
            column(Y2S2_Trans_Val7;Y2S2_Trans_Val[7])
            {
            }
            column(Y2_Trans_Grand_Total7;Y2_Trans_Grand_Total[7])
            {
            }
            column(Y2_Trans_Code7;Y2_Trans_Code[7])
            {
            }
            column(Y2_Trans_Txt8;Y2_Trans_Txt[8])
            {
            }
            column(Y2S1_Trans_Val8;Y2S1_Trans_Val[8])
            {
            }
            column(Y2S2_Trans_Val8;Y2S2_Trans_Val[8])
            {
            }
            column(Y2_Trans_Grand_Total8;Y2_Trans_Grand_Total[8])
            {
            }
            column(Y2_Trans_Code8;Y2_Trans_Code[8])
            {
            }
            column(Y2_Trans_Txt9;Y2_Trans_Txt[9])
            {
            }
            column(Y2S1_Trans_Val9;Y2S1_Trans_Val[9])
            {
            }
            column(Y2S2_Trans_Val9;Y2S2_Trans_Val[9])
            {
            }
            column(Y2_Trans_Grand_Total9;Y2_Trans_Grand_Total[9])
            {
            }
            column(Y2_Trans_Code9;Y2_Trans_Code[9])
            {
            }
            column(Y2_Trans_Txt10;Y2_Trans_Txt[10])
            {
            }
            column(Y2S1_Trans_Val10;Y2S1_Trans_Val[10])
            {
            }
            column(Y2S2_Trans_Val10;Y2S2_Trans_Val[10])
            {
            }
            column(Y2_Trans_Grand_Total10;Y2_Trans_Grand_Total[10])
            {
            }
            column(Y2_Trans_Code10;Y2_Trans_Code[10])
            {
            }
            column(Y2_Trans_Txt11;Y2_Trans_Txt[11])
            {
            }
            column(Y2S1_Trans_Val11;Y2S1_Trans_Val[11])
            {
            }
            column(Y2S2_Trans_Val11;Y2S2_Trans_Val[11])
            {
            }
            column(Y2_Trans_Grand_Total11;Y2_Trans_Grand_Total[11])
            {
            }
            column(Y2_Trans_Code11;Y2_Trans_Code[11])
            {
            }
            column(Y2_Trans_Txt12;Y2_Trans_Txt[12])
            {
            }
            column(Y2S1_Trans_Val12;Y2S1_Trans_Val[12])
            {
            }
            column(Y2S2_Trans_Val12;Y2S2_Trans_Val[12])
            {
            }
            column(Y2_Trans_Grand_Total12;Y2_Trans_Grand_Total[12])
            {
            }
            column(Y2_Trans_Code12;Y2_Trans_Code[12])
            {
            }
            column(Y2_Trans_Txt13;Y2_Trans_Txt[13])
            {
            }
            column(Y2S1_Trans_Val13;Y2S1_Trans_Val[13])
            {
            }
            column(Y2S2_Trans_Val13;Y2S2_Trans_Val[13])
            {
            }
            column(Y2_Trans_Grand_Total13;Y2_Trans_Grand_Total[13])
            {
            }
            column(Y2_Trans_Code13;Y2_Trans_Code[13])
            {
            }
            column(Y2_Trans_Txt14;Y2_Trans_Txt[14])
            {
            }
            column(Y2S1_Trans_Val14;Y2S1_Trans_Val[14])
            {
            }
            column(Y2S2_Trans_Val14;Y2S2_Trans_Val[14])
            {
            }
            column(Y2_Trans_Grand_Total14;Y2_Trans_Grand_Total[14])
            {
            }
            column(Y2_Trans_Code14;Y2_Trans_Code[14])
            {
            }
            column(Y2_Trans_Txt15;Y2_Trans_Txt[15])
            {
            }
            column(Y2S1_Trans_Val15;Y2S1_Trans_Val[15])
            {
            }
            column(Y2S2_Trans_Val15;Y2S2_Trans_Val[15])
            {
            }
            column(Y2_Trans_Grand_Total15;Y2_Trans_Grand_Total[15])
            {
            }
            column(Y2_Trans_Code15;Y2_Trans_Code[15])
            {
            }
            column(Y2_Trans_Txt16;Y2_Trans_Txt[16])
            {
            }
            column(Y2S1_Trans_Val16;Y2S1_Trans_Val[16])
            {
            }
            column(Y2S2_Trans_Val16;Y2S2_Trans_Val[16])
            {
            }
            column(Y2_Trans_Grand_Total16;Y2_Trans_Grand_Total[16])
            {
            }
            column(Y2_Trans_Code16;Y2_Trans_Code[16])
            {
            }
            column(i2;i2)
            {
            }
            column(Y3_ItemLabel;Y3_ItemLabel)
            {
            }
            column(Y3S1_Tuit_Caption;Y3S1_Tuit_Caption)
            {
            }
            column(Y3S2_Tuit_Caption;Y3S2_Tuit_Caption)
            {
            }
            column(Y3_Tuit_Total_Caption;Y3_Tuit_Total_Caption)
            {
            }
            column(Y3S1_Tuit_Caption2;Y3S1_Tuit_Caption2)
            {
            }
            column(Y3S2_Tuit_Caption2;Y3S2_Tuit_Caption2)
            {
            }
            column(Y3_Tuit_Total_Caption2;Y3_Tuit_Total_Caption2)
            {
            }
            column(Y3S1_Tuit_Caption3;Y3S1_Tuit_Caption3)
            {
            }
            column(Y3S2_Tuit_Caption3;Y3S2_Tuit_Caption3)
            {
            }
            column(Y3_Tuit_Total_Caption3;Y3_Tuit_Total_Caption3)
            {
            }
            column(Y3S1_Tuit_Val;Y3S1_Tuit_Val)
            {
            }
            column(Y3S2_Tuit_Val;Y3S2_Tuit_Val)
            {
            }
            column(Y3_Tuit_Total_Val;Y3_Tuit_Total_Val)
            {
            }
            column(Y3_Tuit_txt_lbl1;Y3_Tuit_txt_lbl1)
            {
            }
            column(Y3_Charges_txt_lbl2;Y3_Charges_txt_lbl2)
            {
            }
            column(Y3_Tuit_txt;Y3_Tuit_txt)
            {
            }
            column(Y3_Tuit_txt2;Y3_Tuit_txt2)
            {
            }
            column(Y3_Charges_txt;Y3_Charges_txt)
            {
            }
            column(Y3_Charges_txt2;Y3_Charges_txt2)
            {
            }
            column(Y3_Trans_txt_Footer;Y3_Trans_txt_Footer)
            {
            }
            column(Y3S1_Total;Y3S1_Total)
            {
            }
            column(Y3S2_Total;Y3S2_Total)
            {
            }
            column(Y3_Grand_Total;Y3_Grand_Total)
            {
            }
            column(Y3_Trans_Txt1;Y3_Trans_Txt[1])
            {
            }
            column(Y3S1_Trans_Val1;Y3S1_Trans_Val[1])
            {
            }
            column(Y3S2_Trans_Val1;Y3S2_Trans_Val[1])
            {
            }
            column(Y3_Trans_Grand_Total1;Y3_Trans_Grand_Total[1])
            {
            }
            column(Y3_Trans_Code1;Y3_Trans_Code[1])
            {
            }
            column(Y3_Trans_Txt2;Y3_Trans_Txt[2])
            {
            }
            column(Y3S1_Trans_Val2;Y3S1_Trans_Val[2])
            {
            }
            column(Y3S2_Trans_Val2;Y3S2_Trans_Val[2])
            {
            }
            column(Y3_Trans_Grand_Total2;Y3_Trans_Grand_Total[2])
            {
            }
            column(Y3_Trans_Code2;Y3_Trans_Code[2])
            {
            }
            column(Y3_Trans_Txt3;Y3_Trans_Txt[3])
            {
            }
            column(Y3S1_Trans_Val3;Y3S1_Trans_Val[3])
            {
            }
            column(Y3S2_Trans_Val3;Y3S2_Trans_Val[3])
            {
            }
            column(Y3_Trans_Grand_Total3;Y3_Trans_Grand_Total[3])
            {
            }
            column(Y3_Trans_Code3;Y3_Trans_Code[3])
            {
            }
            column(Y3_Trans_Txt4;Y3_Trans_Txt[4])
            {
            }
            column(Y3S1_Trans_Val4;Y3S1_Trans_Val[4])
            {
            }
            column(Y3S2_Trans_Val4;Y3S2_Trans_Val[4])
            {
            }
            column(Y3_Trans_Grand_Total4;Y3_Trans_Grand_Total[4])
            {
            }
            column(Y3_Trans_Code4;Y3_Trans_Code[4])
            {
            }
            column(Y3_Trans_Txt5;Y3_Trans_Txt[5])
            {
            }
            column(Y3S1_Trans_Val5;Y3S1_Trans_Val[5])
            {
            }
            column(Y3S2_Trans_Val5;Y3S2_Trans_Val[5])
            {
            }
            column(Y3_Trans_Grand_Total5;Y3_Trans_Grand_Total[5])
            {
            }
            column(Y3_Trans_Code5;Y3_Trans_Code[5])
            {
            }
            column(Y3_Trans_Txt6;Y3_Trans_Txt[6])
            {
            }
            column(Y3S1_Trans_Val6;Y3S1_Trans_Val[6])
            {
            }
            column(Y3S2_Trans_Val6;Y3S2_Trans_Val[6])
            {
            }
            column(Y3_Trans_Grand_Total6;Y3_Trans_Grand_Total[6])
            {
            }
            column(Y3_Trans_Code6;Y3_Trans_Code[6])
            {
            }
            column(Y3_Trans_Txt7;Y3_Trans_Txt[7])
            {
            }
            column(Y3S1_Trans_Val7;Y3S1_Trans_Val[7])
            {
            }
            column(Y3S2_Trans_Val7;Y3S2_Trans_Val[7])
            {
            }
            column(Y3_Trans_Grand_Total7;Y3_Trans_Grand_Total[7])
            {
            }
            column(Y3_Trans_Code7;Y3_Trans_Code[7])
            {
            }
            column(Y3_Trans_Txt8;Y3_Trans_Txt[8])
            {
            }
            column(Y3S1_Trans_Val8;Y3S1_Trans_Val[8])
            {
            }
            column(Y3S2_Trans_Val8;Y3S2_Trans_Val[8])
            {
            }
            column(Y3_Trans_Grand_Total8;Y3_Trans_Grand_Total[8])
            {
            }
            column(Y3_Trans_Code8;Y3_Trans_Code[8])
            {
            }
            column(Y3_Trans_Txt9;Y3_Trans_Txt[9])
            {
            }
            column(Y3S1_Trans_Val9;Y3S1_Trans_Val[9])
            {
            }
            column(Y3S2_Trans_Val9;Y3S2_Trans_Val[9])
            {
            }
            column(Y3_Trans_Grand_Total9;Y3_Trans_Grand_Total[9])
            {
            }
            column(Y3_Trans_Code9;Y3_Trans_Code[9])
            {
            }
            column(Y3_Trans_Txt10;Y3_Trans_Txt[10])
            {
            }
            column(Y3S1_Trans_Val10;Y3S1_Trans_Val[10])
            {
            }
            column(Y3S2_Trans_Val10;Y3S2_Trans_Val[10])
            {
            }
            column(Y3_Trans_Grand_Total10;Y3_Trans_Grand_Total[10])
            {
            }
            column(Y3_Trans_Code10;Y3_Trans_Code[10])
            {
            }
            column(Y3_Trans_Txt11;Y3_Trans_Txt[11])
            {
            }
            column(Y3S1_Trans_Val11;Y3S1_Trans_Val[11])
            {
            }
            column(Y3S2_Trans_Val11;Y3S2_Trans_Val[11])
            {
            }
            column(Y3_Trans_Grand_Total11;Y3_Trans_Grand_Total[11])
            {
            }
            column(Y3_Trans_Code11;Y3_Trans_Code[11])
            {
            }
            column(Y3_Trans_Txt12;Y3_Trans_Txt[12])
            {
            }
            column(Y3S1_Trans_Val12;Y3S1_Trans_Val[12])
            {
            }
            column(Y3S2_Trans_Val12;Y3S2_Trans_Val[12])
            {
            }
            column(Y3_Trans_Grand_Total12;Y3_Trans_Grand_Total[12])
            {
            }
            column(Y3_Trans_Code12;Y3_Trans_Code[12])
            {
            }
            column(Y3_Trans_Txt13;Y3_Trans_Txt[13])
            {
            }
            column(Y3S1_Trans_Val13;Y3S1_Trans_Val[13])
            {
            }
            column(Y3S2_Trans_Val13;Y3S2_Trans_Val[13])
            {
            }
            column(Y3_Trans_Grand_Total13;Y3_Trans_Grand_Total[13])
            {
            }
            column(Y3_Trans_Code13;Y3_Trans_Code[13])
            {
            }
            column(Y3_Trans_Txt14;Y3_Trans_Txt[14])
            {
            }
            column(Y3S1_Trans_Val14;Y3S1_Trans_Val[14])
            {
            }
            column(Y3S2_Trans_Val14;Y3S2_Trans_Val[14])
            {
            }
            column(Y3_Trans_Grand_Total14;Y3_Trans_Grand_Total[14])
            {
            }
            column(Y3_Trans_Code14;Y3_Trans_Code[14])
            {
            }
            column(Y3_Trans_Txt15;Y3_Trans_Txt[15])
            {
            }
            column(Y3S1_Trans_Val15;Y3S1_Trans_Val[15])
            {
            }
            column(Y3S2_Trans_Val15;Y3S2_Trans_Val[15])
            {
            }
            column(Y3_Trans_Grand_Total15;Y3_Trans_Grand_Total[15])
            {
            }
            column(Y3_Trans_Code15;Y3_Trans_Code[15])
            {
            }
            column(Y3_Trans_Txt16;Y3_Trans_Txt[16])
            {
            }
            column(Y3S1_Trans_Val16;Y3S1_Trans_Val[16])
            {
            }
            column(Y3S2_Trans_Val16;Y3S2_Trans_Val[16])
            {
            }
            column(Y3_Trans_Grand_Total16;Y3_Trans_Grand_Total[16])
            {
            }
            column(Y3_Trans_Code16;Y3_Trans_Code[16])
            {
            }
            column(i3;i3)
            {
            }
            column(Y4_ItemLabel;Y4_ItemLabel)
            {
            }
            column(Y4S1_Tuit_Caption;Y4S1_Tuit_Caption)
            {
            }
            column(Y4S2_Tuit_Caption;Y4S2_Tuit_Caption)
            {
            }
            column(Y4_Tuit_Total_Caption;Y4_Tuit_Total_Caption)
            {
            }
            column(Y4S1_Tuit_Caption2;Y4S1_Tuit_Caption2)
            {
            }
            column(Y4S2_Tuit_Caption2;Y4S2_Tuit_Caption2)
            {
            }
            column(Y4_Tuit_Total_Caption2;Y4_Tuit_Total_Caption2)
            {
            }
            column(Y4S1_Tuit_Caption3;Y4S1_Tuit_Caption3)
            {
            }
            column(Y4S2_Tuit_Caption3;Y4S2_Tuit_Caption3)
            {
            }
            column(Y4_Tuit_Total_Caption3;Y4_Tuit_Total_Caption3)
            {
            }
            column(Y4S1_Tuit_Val;Y4S1_Tuit_Val)
            {
            }
            column(Y4S2_Tuit_Val;Y4S2_Tuit_Val)
            {
            }
            column(Y4_Tuit_Total_Val;Y4_Tuit_Total_Val)
            {
            }
            column(Y4_Tuit_txt_lbl1;Y4_Tuit_txt_lbl1)
            {
            }
            column(Y4_Charges_txt_lbl2;Y4_Charges_txt_lbl2)
            {
            }
            column(Y4_Tuit_txt;Y4_Tuit_txt)
            {
            }
            column(Y4_Tuit_txt2;Y4_Tuit_txt2)
            {
            }
            column(Y4_Charges_txt;Y4_Charges_txt)
            {
            }
            column(Y4_Charges_txt2;Y4_Charges_txt2)
            {
            }
            column(Y4_Trans_txt_Footer;Y4_Trans_txt_Footer)
            {
            }
            column(Y4S1_Total;Y4S1_Total)
            {
            }
            column(Y4S2_Total;Y4S2_Total)
            {
            }
            column(Y4_Grand_Total;Y4_Grand_Total)
            {
            }
            column(Y4_Trans_Txt1;Y4_Trans_Txt[1])
            {
            }
            column(Y4S1_Trans_Val1;Y4S1_Trans_Val[1])
            {
            }
            column(Y4S2_Trans_Val1;Y4S2_Trans_Val[1])
            {
            }
            column(Y4_Trans_Grand_Total1;Y4_Trans_Grand_Total[1])
            {
            }
            column(Y4_Trans_Code1;Y4_Trans_Code[1])
            {
            }
            column(Y4_Trans_Txt2;Y4_Trans_Txt[2])
            {
            }
            column(Y4S1_Trans_Val2;Y4S1_Trans_Val[2])
            {
            }
            column(Y4S2_Trans_Val2;Y4S2_Trans_Val[2])
            {
            }
            column(Y4_Trans_Grand_Total2;Y4_Trans_Grand_Total[2])
            {
            }
            column(Y4_Trans_Code2;Y4_Trans_Code[2])
            {
            }
            column(Y4_Trans_Txt3;Y4_Trans_Txt[3])
            {
            }
            column(Y4S1_Trans_Val3;Y4S1_Trans_Val[3])
            {
            }
            column(Y4S2_Trans_Val3;Y4S2_Trans_Val[3])
            {
            }
            column(Y4_Trans_Grand_Total3;Y4_Trans_Grand_Total[3])
            {
            }
            column(Y4_Trans_Code3;Y4_Trans_Code[3])
            {
            }
            column(Y4_Trans_Txt4;Y4_Trans_Txt[4])
            {
            }
            column(Y4S1_Trans_Val4;Y4S1_Trans_Val[4])
            {
            }
            column(Y4S2_Trans_Val4;Y4S2_Trans_Val[4])
            {
            }
            column(Y4_Trans_Grand_Total4;Y4_Trans_Grand_Total[4])
            {
            }
            column(Y4_Trans_Code4;Y4_Trans_Code[4])
            {
            }
            column(Y4_Trans_Txt5;Y4_Trans_Txt[5])
            {
            }
            column(Y4S1_Trans_Val5;Y4S1_Trans_Val[5])
            {
            }
            column(Y4S2_Trans_Val5;Y4S2_Trans_Val[5])
            {
            }
            column(Y4_Trans_Grand_Total5;Y4_Trans_Grand_Total[5])
            {
            }
            column(Y4_Trans_Code5;Y4_Trans_Code[5])
            {
            }
            column(Y4_Trans_Txt6;Y4_Trans_Txt[6])
            {
            }
            column(Y4S1_Trans_Val6;Y4S1_Trans_Val[6])
            {
            }
            column(Y4S2_Trans_Val6;Y4S2_Trans_Val[6])
            {
            }
            column(Y4_Trans_Grand_Total6;Y4_Trans_Grand_Total[6])
            {
            }
            column(Y4_Trans_Code6;Y4_Trans_Code[6])
            {
            }
            column(Y4_Trans_Txt7;Y4_Trans_Txt[7])
            {
            }
            column(Y4S1_Trans_Val7;Y4S1_Trans_Val[7])
            {
            }
            column(Y4S2_Trans_Val7;Y4S2_Trans_Val[7])
            {
            }
            column(Y4_Trans_Grand_Total7;Y4_Trans_Grand_Total[7])
            {
            }
            column(Y4_Trans_Code7;Y4_Trans_Code[7])
            {
            }
            column(Y4_Trans_Txt8;Y4_Trans_Txt[8])
            {
            }
            column(Y4S1_Trans_Val8;Y4S1_Trans_Val[8])
            {
            }
            column(Y4S2_Trans_Val8;Y4S2_Trans_Val[8])
            {
            }
            column(Y4_Trans_Grand_Total8;Y4_Trans_Grand_Total[8])
            {
            }
            column(Y4_Trans_Code8;Y4_Trans_Code[8])
            {
            }
            column(Y4_Trans_Txt9;Y4_Trans_Txt[9])
            {
            }
            column(Y4S1_Trans_Val9;Y4S1_Trans_Val[9])
            {
            }
            column(Y4S2_Trans_Val9;Y4S2_Trans_Val[9])
            {
            }
            column(Y4_Trans_Grand_Total9;Y4_Trans_Grand_Total[9])
            {
            }
            column(Y4_Trans_Code9;Y4_Trans_Code[9])
            {
            }
            column(Y4_Trans_Txt10;Y4_Trans_Txt[10])
            {
            }
            column(Y4S1_Trans_Val10;Y4S1_Trans_Val[10])
            {
            }
            column(Y4S2_Trans_Val10;Y4S2_Trans_Val[10])
            {
            }
            column(Y4_Trans_Grand_Total10;Y4_Trans_Grand_Total[10])
            {
            }
            column(Y4_Trans_Code10;Y4_Trans_Code[10])
            {
            }
            column(Y4_Trans_Txt11;Y4_Trans_Txt[11])
            {
            }
            column(Y4S1_Trans_Val11;Y4S1_Trans_Val[11])
            {
            }
            column(Y4S2_Trans_Val11;Y4S2_Trans_Val[11])
            {
            }
            column(Y4_Trans_Grand_Total11;Y4_Trans_Grand_Total[11])
            {
            }
            column(Y4_Trans_Code11;Y4_Trans_Code[11])
            {
            }
            column(Y4_Trans_Txt12;Y4_Trans_Txt[12])
            {
            }
            column(Y4S1_Trans_Val12;Y4S1_Trans_Val[12])
            {
            }
            column(Y4S2_Trans_Val12;Y4S2_Trans_Val[12])
            {
            }
            column(Y4_Trans_Grand_Total12;Y4_Trans_Grand_Total[12])
            {
            }
            column(Y4_Trans_Code12;Y4_Trans_Code[12])
            {
            }
            column(Y4_Trans_Txt13;Y4_Trans_Txt[13])
            {
            }
            column(Y4S1_Trans_Val13;Y4S1_Trans_Val[13])
            {
            }
            column(Y4S2_Trans_Val13;Y4S2_Trans_Val[13])
            {
            }
            column(Y4_Trans_Grand_Total13;Y4_Trans_Grand_Total[13])
            {
            }
            column(Y4_Trans_Code13;Y4_Trans_Code[13])
            {
            }
            column(Y4_Trans_Txt14;Y4_Trans_Txt[14])
            {
            }
            column(Y4S1_Trans_Val14;Y4S1_Trans_Val[14])
            {
            }
            column(Y4S2_Trans_Val14;Y4S2_Trans_Val[14])
            {
            }
            column(Y4_Trans_Grand_Total14;Y4_Trans_Grand_Total[14])
            {
            }
            column(Y4_Trans_Code14;Y4_Trans_Code[14])
            {
            }
            column(Y4_Trans_Txt15;Y4_Trans_Txt[15])
            {
            }
            column(Y4S1_Trans_Val15;Y4S1_Trans_Val[15])
            {
            }
            column(Y4S2_Trans_Val15;Y4S2_Trans_Val[15])
            {
            }
            column(Y4_Trans_Grand_Total15;Y4_Trans_Grand_Total[15])
            {
            }
            column(Y4_Trans_Code15;Y4_Trans_Code[15])
            {
            }
            column(Y4_Trans_Txt16;Y4_Trans_Txt[16])
            {
            }
            column(Y4S1_Trans_Val16;Y4S1_Trans_Val[16])
            {
            }
            column(Y4S2_Trans_Val16;Y4S2_Trans_Val[16])
            {
            }
            column(Y4_Trans_Grand_Total16;Y4_Trans_Grand_Total[16])
            {
            }
            column(Y4_Trans_Code16;Y4_Trans_Code[16])
            {
            }
            column(i4;i4)
            {
            }
            column(Y5_ItemLabel;Y5_ItemLabel)
            {
            }
            column(Y5S1_Tuit_Caption;Y5S1_Tuit_Caption)
            {
            }
            column(Y5S2_Tuit_Caption;Y5S2_Tuit_Caption)
            {
            }
            column(Y5_Tuit_Total_Caption;Y5_Tuit_Total_Caption)
            {
            }
            column(Y5S1_Tuit_Caption2;Y5S1_Tuit_Caption2)
            {
            }
            column(Y5S2_Tuit_Caption2;Y5S2_Tuit_Caption2)
            {
            }
            column(Y5_Tuit_Total_Caption2;Y5_Tuit_Total_Caption2)
            {
            }
            column(Y5S1_Tuit_Caption3;Y5S1_Tuit_Caption3)
            {
            }
            column(Y5S2_Tuit_Caption3;Y5S2_Tuit_Caption3)
            {
            }
            column(Y5_Tuit_Total_Caption3;Y5_Tuit_Total_Caption3)
            {
            }
            column(Y5S1_Tuit_Val;Y5S1_Tuit_Val)
            {
            }
            column(Y5S2_Tuit_Val;Y5S2_Tuit_Val)
            {
            }
            column(Y5_Tuit_Total_Val;Y5_Tuit_Total_Val)
            {
            }
            column(Y5_Tuit_txt_lbl1;Y5_Tuit_txt_lbl1)
            {
            }
            column(Y5_Charges_txt_lbl2;Y5_Charges_txt_lbl2)
            {
            }
            column(Y5_Tuit_txt;Y5_Tuit_txt)
            {
            }
            column(Y5_Tuit_txt2;Y5_Tuit_txt2)
            {
            }
            column(Y5_Charges_txt;Y5_Charges_txt)
            {
            }
            column(Y5_Charges_txt2;Y5_Charges_txt2)
            {
            }
            column(Y5_Trans_txt_Footer;Y5_Trans_txt_Footer)
            {
            }
            column(Y5S1_Total;Y5S1_Total)
            {
            }
            column(Y5S2_Total;Y5S2_Total)
            {
            }
            column(Y5_Grand_Total;Y5_Grand_Total)
            {
            }
            column(Y5_Trans_Txt1;Y5_Trans_Txt[1])
            {
            }
            column(Y5S1_Trans_Val1;Y5S1_Trans_Val[1])
            {
            }
            column(Y5S2_Trans_Val1;Y5S2_Trans_Val[1])
            {
            }
            column(Y5_Trans_Grand_Total1;Y5_Trans_Grand_Total[1])
            {
            }
            column(Y5_Trans_Code1;Y5_Trans_Code[1])
            {
            }
            column(Y5_Trans_Txt2;Y5_Trans_Txt[2])
            {
            }
            column(Y5S1_Trans_Val2;Y5S1_Trans_Val[2])
            {
            }
            column(Y5S2_Trans_Val2;Y5S2_Trans_Val[2])
            {
            }
            column(Y5_Trans_Grand_Total2;Y5_Trans_Grand_Total[2])
            {
            }
            column(Y5_Trans_Code2;Y5_Trans_Code[2])
            {
            }
            column(Y5_Trans_Txt3;Y5_Trans_Txt[3])
            {
            }
            column(Y5S1_Trans_Val3;Y5S1_Trans_Val[3])
            {
            }
            column(Y5S2_Trans_Val3;Y5S2_Trans_Val[3])
            {
            }
            column(Y5_Trans_Grand_Total3;Y5_Trans_Grand_Total[3])
            {
            }
            column(Y5_Trans_Code3;Y5_Trans_Code[3])
            {
            }
            column(Y5_Trans_Txt4;Y5_Trans_Txt[4])
            {
            }
            column(Y5S1_Trans_Val4;Y5S1_Trans_Val[4])
            {
            }
            column(Y5S2_Trans_Val4;Y5S2_Trans_Val[4])
            {
            }
            column(Y5_Trans_Grand_Total4;Y5_Trans_Grand_Total[4])
            {
            }
            column(Y5_Trans_Code4;Y5_Trans_Code[4])
            {
            }
            column(Y5_Trans_Txt5;Y5_Trans_Txt[5])
            {
            }
            column(Y5S1_Trans_Val5;Y5S1_Trans_Val[5])
            {
            }
            column(Y5S2_Trans_Val5;Y5S2_Trans_Val[5])
            {
            }
            column(Y5_Trans_Grand_Total5;Y5_Trans_Grand_Total[5])
            {
            }
            column(Y5_Trans_Code5;Y5_Trans_Code[5])
            {
            }
            column(Y5_Trans_Txt6;Y5_Trans_Txt[6])
            {
            }
            column(Y5S1_Trans_Val6;Y5S1_Trans_Val[6])
            {
            }
            column(Y5S2_Trans_Val6;Y5S2_Trans_Val[6])
            {
            }
            column(Y5_Trans_Grand_Total6;Y5_Trans_Grand_Total[6])
            {
            }
            column(Y5_Trans_Code6;Y5_Trans_Code[6])
            {
            }
            column(Y5_Trans_Txt7;Y5_Trans_Txt[7])
            {
            }
            column(Y5S1_Trans_Val7;Y5S1_Trans_Val[7])
            {
            }
            column(Y5S2_Trans_Val7;Y5S2_Trans_Val[7])
            {
            }
            column(Y5_Trans_Grand_Total7;Y5_Trans_Grand_Total[7])
            {
            }
            column(Y5_Trans_Code7;Y5_Trans_Code[7])
            {
            }
            column(Y5_Trans_Txt8;Y5_Trans_Txt[8])
            {
            }
            column(Y5S1_Trans_Val8;Y5S1_Trans_Val[8])
            {
            }
            column(Y5S2_Trans_Val8;Y5S2_Trans_Val[8])
            {
            }
            column(Y5_Trans_Grand_Total8;Y5_Trans_Grand_Total[8])
            {
            }
            column(Y5_Trans_Code8;Y5_Trans_Code[8])
            {
            }
            column(Y5_Trans_Txt9;Y5_Trans_Txt[9])
            {
            }
            column(Y5S1_Trans_Val9;Y5S1_Trans_Val[9])
            {
            }
            column(Y5S2_Trans_Val9;Y5S2_Trans_Val[9])
            {
            }
            column(Y5_Trans_Grand_Total9;Y5_Trans_Grand_Total[9])
            {
            }
            column(Y5_Trans_Code9;Y5_Trans_Code[9])
            {
            }
            column(Y5_Trans_Txt10;Y5_Trans_Txt[10])
            {
            }
            column(Y5S1_Trans_Val10;Y5S1_Trans_Val[10])
            {
            }
            column(Y5S2_Trans_Val10;Y5S2_Trans_Val[10])
            {
            }
            column(Y5_Trans_Grand_Total10;Y5_Trans_Grand_Total[10])
            {
            }
            column(Y5_Trans_Code10;Y5_Trans_Code[10])
            {
            }
            column(Y5_Trans_Txt11;Y5_Trans_Txt[11])
            {
            }
            column(Y5S1_Trans_Val11;Y5S1_Trans_Val[11])
            {
            }
            column(Y5S2_Trans_Val11;Y5S2_Trans_Val[11])
            {
            }
            column(Y5_Trans_Grand_Total11;Y5_Trans_Grand_Total[11])
            {
            }
            column(Y5_Trans_Code11;Y5_Trans_Code[11])
            {
            }
            column(Y5_Trans_Txt12;Y5_Trans_Txt[12])
            {
            }
            column(Y5S1_Trans_Val12;Y5S1_Trans_Val[12])
            {
            }
            column(Y5S2_Trans_Val12;Y5S2_Trans_Val[12])
            {
            }
            column(Y5_Trans_Grand_Total12;Y5_Trans_Grand_Total[12])
            {
            }
            column(Y5_Trans_Code12;Y5_Trans_Code[12])
            {
            }
            column(Y5_Trans_Txt13;Y5_Trans_Txt[13])
            {
            }
            column(Y5S1_Trans_Val13;Y5S1_Trans_Val[13])
            {
            }
            column(Y5S2_Trans_Val13;Y5S2_Trans_Val[13])
            {
            }
            column(Y5_Trans_Grand_Total13;Y5_Trans_Grand_Total[13])
            {
            }
            column(Y5_Trans_Code13;Y5_Trans_Code[13])
            {
            }
            column(Y5_Trans_Txt14;Y5_Trans_Txt[14])
            {
            }
            column(Y5S1_Trans_Val14;Y5S1_Trans_Val[14])
            {
            }
            column(Y5S2_Trans_Val14;Y5S2_Trans_Val[14])
            {
            }
            column(Y5_Trans_Grand_Total14;Y5_Trans_Grand_Total[14])
            {
            }
            column(Y5_Trans_Code14;Y5_Trans_Code[14])
            {
            }
            column(Y5_Trans_Txt15;Y5_Trans_Txt[15])
            {
            }
            column(Y5S1_Trans_Val15;Y5S1_Trans_Val[15])
            {
            }
            column(Y5S2_Trans_Val15;Y5S2_Trans_Val[15])
            {
            }
            column(Y5_Trans_Grand_Total15;Y5_Trans_Grand_Total[15])
            {
            }
            column(Y5_Trans_Code15;Y5_Trans_Code[15])
            {
            }
            column(Y5_Trans_Txt16;Y5_Trans_Txt[16])
            {
            }
            column(Y5S1_Trans_Val16;Y5S1_Trans_Val[16])
            {
            }
            column(Y5S2_Trans_Val16;Y5S2_Trans_Val[16])
            {
            }
            column(Y5_Trans_Grand_Total16;Y5_Trans_Grand_Total[16])
            {
            }
            column(Y5_Trans_Code16;Y5_Trans_Code[16])
            {
            }
            column(i5;i5)
            {
            }

            trigger OnAfterGetRecord()
            begin
                  // Initialize all Variables
                  clearVariables1();
                  clearVariables2();
                  clearVariables3();
                  clearVariables4();
                  clearVariables5();
                progStages.Reset;
                progStages.SetRange(progStages."Programme Code","ACA-Programme".Code);
                if progStages.Find('-') then begin
                  repeat
                    begin
                      if (CopyStr(progStages.Code,1,2)='Y1') then begin // Check if the stage is for First Years
                        if Y1='' then Y1:='ACADEMIC YEAR - 1ST YEAR STUDENTS';
                        Y1_ItemLabel:='ITEM';
                        Y1S1_Tuit_Caption:='FIRST';
                        Y1S2_Tuit_Caption:='SEMESTER';
                        Y1_Tuit_Total_Caption:='(KES)';
                        Y1S1_Tuit_Caption2:='SECOND';
                        Y1S2_Tuit_Caption2:='SEMESTER';
                        Y1_Tuit_Total_Caption2:='(KES)';
                        Y1S1_Tuit_Caption3:='TOTAL PER';
                        Y1S2_Tuit_Caption3:='YEAR';
                        Y1_Tuit_Total_Caption3:='(KES)';
                        Y1_Tuit_txt_lbl1:='A. TUITION: ';
                        Y1_Charges_txt_lbl2:='B. OTHER CHARGES: ';
                        Y1_Tuit_txt:='to be paid to the University';
                        Y1_Tuit_txt2:='on the registration day';
                        Y1_Charges_txt:='To bepaid to the ';
                        Y1_Charges_txt2:='University on the registration day';
                        Y1_Trans_txt_Footer:='TOTAL FEE PAYABLE TO KARATINA UNIVERSITY';
                        /// Fetch Charges and populate here
                        //********************************************Y1**************************************************//
                          // Fetch Charges per Stage for 1st Year 1st Sem Here
                            if progStages.Code = 'Y1S1' then begin //4
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y1S1');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y1S1 Charges Loop 1
                                // Charges for Y1S1 Exists
                                //Fetch Name for the charge
                                if charges.Get(stage_Charge.Code) then
                                if not ((charges.Description) in [Y1_Trans_Txt[1]..Y1_Trans_Txt[13]]) then begin // Charge Item Has not been Fetched already //2
                                //
                                i1:=CompressArray(Y1_Trans_Txt)+1;
                                Y1_Trans_Code[i1]:=stage_Charge.Code;
                                   Y1_Trans_Txt[i1]:=charges.Description;
                                   Y1S1_Trans_Val[i1]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[i1]:=Y1_Trans_Grand_Total[i1]+Y1S1_Trans_Val[i1];
                                   Y1S1_Total:=Y1S1_Total+Y1S1_Trans_Val[i1];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S1_Trans_Val[i1];
                                end; //2
                                end; // end for Y1S1 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y1S1
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y1S1');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y1S1_Tuit_Val:=FeeByStage."Break Down";
                                Y1_Tuit_Total_Val:=Y1_Tuit_Total_Val+Y1S1_Tuit_Val;
                                Y1S1_Total:=Y1S1_Total+Y1S1_Tuit_Val;
                                Y1_Grand_Total:=Y1_Grand_Total+Y1S1_Tuit_Val;
                              end; // 6
                            end else if progStages.Code = 'Y1S2' then begin // 4/5
                              Clear(counts);
                              begin // 7
                              counts:=counts+1;
                          // Fetch Charges per Stage for 1st Year 2nd sem Here
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              //stage_Charge.setrange(stage_Charge.Code,Y1_Trans_Code[counts]);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y1S2');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y1S2 Charges Loop 1
                                // Charges for Y1S2 Exists
                                //Fetch Name for the charge
                                //ERROR(Y1_Trans_Txt[1]+': '+Y1_Trans_Txt[2]);
                                if charges.Get(stage_Charge.Code) then
                                //IF NOT ((charges.Description) IN [Y1_Trans_Txt[1]..Y1_Trans_Txt[13]]) THEN BEGIN // Charge Item Has not been Fetched already //2
                                if not (((charges.Description=Y1_Trans_Txt[1]) or (charges.Description=Y1_Trans_Txt[2])
                                or (charges.Description=Y1_Trans_Txt[3]) or (charges.Description=Y1_Trans_Txt[4])
                                or (charges.Description=Y1_Trans_Txt[5]) or (charges.Description=Y1_Trans_Txt[6])
                                or (charges.Description=Y1_Trans_Txt[7]) or (charges.Description=Y1_Trans_Txt[8])
                                or (charges.Description=Y1_Trans_Txt[9]) or (charges.Description=Y1_Trans_Txt[10])
                                or (charges.Description=Y1_Trans_Txt[11]) or (charges.Description=Y1_Trans_Txt[12])
                                or (charges.Description=Y1_Trans_Txt[13])))  then begin // Charge Item Has not been Fetched already //2
                                //
                                i1:=(CompressArray(Y1_Trans_Txt))+1;
                                Y1_Trans_Code[i1]:=stage_Charge.Code;
                                   Y1_Trans_Txt[i1]:=charges.Description;
                                   Y1S2_Trans_Val[i1]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[i1]:=Y1_Trans_Grand_Total[i1]+Y1S2_Trans_Val[i1];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[i1];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[i1];
                                end  //2
                                else begin//10 If the Item has notyet been picked
                                  if charges.Description = Y1_Trans_Txt[1] then begin
                                Y1_Trans_Code[1]:=stage_Charge.Code;
                                   Y1_Trans_Txt[1]:=charges.Description;
                                   Y1S2_Trans_Val[1]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[1]:=Y1_Trans_Grand_Total[1]+Y1S2_Trans_Val[1];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[1];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[1];
                                  end else if charges.Description = Y1_Trans_Txt[2] then begin
                                Y1_Trans_Code[2]:=stage_Charge.Code;
                                   Y1_Trans_Txt[2]:=charges.Description;
                                   Y1S2_Trans_Val[2]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[2]:=Y1_Trans_Grand_Total[2]+Y1S2_Trans_Val[2];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[2];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[2];
                                  end else if charges.Description = Y1_Trans_Txt[3] then begin
                                Y1_Trans_Code[3]:=stage_Charge.Code;
                                   Y1_Trans_Txt[3]:=charges.Description;
                                   Y1S2_Trans_Val[3]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[3]:=Y1_Trans_Grand_Total[3]+Y1S2_Trans_Val[3];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[3];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[3];

                                  end else if charges.Description = Y1_Trans_Txt[4] then begin
                                Y1_Trans_Code[4]:=stage_Charge.Code;
                                   Y1_Trans_Txt[4]:=charges.Description;
                                   Y1S2_Trans_Val[4]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[4]:=Y1_Trans_Grand_Total[4]+Y1S2_Trans_Val[4];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[4];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[4];

                                  end else if charges.Description = Y1_Trans_Txt[5] then begin
                                Y1_Trans_Code[5]:=stage_Charge.Code;
                                   Y1_Trans_Txt[5]:=charges.Description;
                                   Y1S2_Trans_Val[5]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[5]:=Y1_Trans_Grand_Total[5]+Y1S2_Trans_Val[5];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[5];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[5];

                                  end else if charges.Description = Y1_Trans_Txt[6] then begin
                                Y1_Trans_Code[6]:=stage_Charge.Code;
                                   Y1_Trans_Txt[6]:=charges.Description;
                                   Y1S2_Trans_Val[6]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[6]:=Y1_Trans_Grand_Total[6]+Y1S2_Trans_Val[6];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[6];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[6];

                                  end else if charges.Description = Y1_Trans_Txt[7] then begin
                                Y1_Trans_Code[7]:=stage_Charge.Code;
                                   Y1_Trans_Txt[7]:=charges.Description;
                                   Y1S2_Trans_Val[7]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[7]:=Y1_Trans_Grand_Total[7]+Y1S2_Trans_Val[7];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[7];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[7];

                                  end else if charges.Description = Y1_Trans_Txt[8] then begin
                                Y1_Trans_Code[8]:=stage_Charge.Code;
                                   Y1_Trans_Txt[8]:=charges.Description;
                                   Y1S2_Trans_Val[8]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[8]:=Y1_Trans_Grand_Total[8]+Y1S2_Trans_Val[8];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[8];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[8];

                                  end else if charges.Description = Y1_Trans_Txt[9] then begin
                                Y1_Trans_Code[9]:=stage_Charge.Code;
                                   Y1_Trans_Txt[9]:=charges.Description;
                                   Y1S2_Trans_Val[9]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[9]:=Y1_Trans_Grand_Total[9]+Y1S2_Trans_Val[9];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[9];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[9];

                                  end else if charges.Description = Y1_Trans_Txt[10] then begin
                                Y1_Trans_Code[10]:=stage_Charge.Code;
                                   Y1_Trans_Txt[10]:=charges.Description;
                                   Y1S2_Trans_Val[10]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[10]:=Y1_Trans_Grand_Total[10]+Y1S2_Trans_Val[10];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[10];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[10];

                                  end else if charges.Description = Y1_Trans_Txt[11] then begin
                                Y1_Trans_Code[11]:=stage_Charge.Code;
                                   Y1_Trans_Txt[11]:=charges.Description;
                                   Y1S2_Trans_Val[11]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[11]:=Y1_Trans_Grand_Total[11]+Y1S2_Trans_Val[11];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[11];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[11];

                                  end else if charges.Description = Y1_Trans_Txt[12] then begin
                                Y1_Trans_Code[12]:=stage_Charge.Code;
                                   Y1_Trans_Txt[12]:=charges.Description;
                                   Y1S2_Trans_Val[12]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[12]:=Y1_Trans_Grand_Total[12]+Y1S2_Trans_Val[12];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[12];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[12];

                                  end else if charges.Description = Y1_Trans_Txt[13] then begin
                                Y1_Trans_Code[13]:=stage_Charge.Code;
                                   Y1_Trans_Txt[13]:=charges.Description;
                                   Y1S2_Trans_Val[13]:=stage_Charge.Amount;
                                   Y1_Trans_Grand_Total[13]:=Y1_Trans_Grand_Total[13]+Y1S2_Trans_Val[13];
                                   Y1S2_Total:=Y1S2_Total+Y1S2_Trans_Val[13];
                                   Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Trans_Val[13];
                                end;
                                end;//10
                                end; // end for Y1S2 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y1S2
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y1S2');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y1S2_Tuit_Val:=FeeByStage."Break Down";
                                Y1_Tuit_Total_Val:=Y1_Tuit_Total_Val+Y1S2_Tuit_Val;
                                Y1S2_Total:=Y1S2_Total+Y1S2_Tuit_Val;
                                Y1_Grand_Total:=Y1_Grand_Total+Y1S2_Tuit_Val;
                              end; // 6

                              end;// 7
                            end; //5
                         //**************************************END Y1 END***********************************************//
                      end else if (CopyStr(progStages.Code,1,2)='Y2') then begin // Check if the stage is for 2nd Years
                      //clearVariables2();
                        if Y2='' then Y2:='ACADEMIC YEAR - 2ND YEAR STUDENTS';


                        Y2_ItemLabel:='ITEM';
                        Y2S1_Tuit_Caption:='FIRST';
                        Y2S2_Tuit_Caption:='SEMESTER';
                        Y2_Tuit_Total_Caption:='(KES)';
                        Y2S1_Tuit_Caption2:='SECOND';
                        Y2S2_Tuit_Caption2:='SEMESTER';
                        Y2_Tuit_Total_Caption2:='(KES)';
                        Y2S1_Tuit_Caption3:='TOTAL PER';
                        Y2S2_Tuit_Caption3:='YEAR';
                        Y2_Tuit_Total_Caption3:='(KES)';
                        Y2_Tuit_txt_lbl1:='A. TUITION: ';
                        Y2_Charges_txt_lbl2:='B. OTHER CHARGES: ';
                        Y2_Tuit_txt:='to be paid to the University';
                        Y2_Tuit_txt2:='on the registration day';
                        Y2_Charges_txt:='To bepaid to the ';
                        Y2_Charges_txt2:='University on the registration day';
                        Y2_Trans_txt_Footer:='TOTAL FEE PAYABLE TO KARATINA UNIVERSITY';
                        /// Fetch Charges and populate here
                        //********************************************Y2**************************************************//
                          // Fetch Charges per Stage for 1st Year 1st Sem Here
                            if progStages.Code = 'Y2S1' then begin //4
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y2S1');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y2S1 Charges Loop 1
                                // Charges for Y2S1 Exists
                                //Fetch Name for the charge
                                if charges.Get(stage_Charge.Code) then
                                if not ((charges.Description) in [Y2_Trans_Txt[1]..Y2_Trans_Txt[13]]) then begin // Charge Item Has not been Fetched already //2
                                //
                                i2:=CompressArray(Y2_Trans_Txt)+1;
                                Y2_Trans_Code[i2]:=stage_Charge.Code;
                                   Y2_Trans_Txt[i2]:=charges.Description;
                                   Y2S1_Trans_Val[i2]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[i2]:=Y2_Trans_Grand_Total[i2]+Y2S1_Trans_Val[i2];
                                   Y2S1_Total:=Y2S1_Total+Y2S1_Trans_Val[i2];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S1_Trans_Val[i2];
                                end; //2
                                end; // end for Y2S1 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y2S1
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y2S1');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y2S1_Tuit_Val:=FeeByStage."Break Down";
                                Y2_Tuit_Total_Val:=Y2_Tuit_Total_Val+Y2S1_Tuit_Val;
                                Y2S1_Total:=Y2S1_Total+Y2S1_Tuit_Val;
                                Y2_Grand_Total:=Y2_Grand_Total+Y2S1_Tuit_Val;
                              end; // 6
                            end else if progStages.Code = 'Y2S2' then begin // 4/5
                              Clear(counts);
                              begin // 7
                              counts:=counts+1;
                          // Fetch Charges per Stage for 1st Year 2nd sem Here
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              //stage_Charge.setrange(stage_Charge.Code,Y2_Trans_Code[counts]);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y2S2');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y2S2 Charges Loop 1
                                // Charges for Y2S2 Exists
                                //Fetch Name for the charge
                                //ERROR(Y2_Trans_Txt[1]+': '+Y2_Trans_Txt[2]);
                                if charges.Get(stage_Charge.Code) then
                                //IF NOT ((charges.Description) IN [Y2_Trans_Txt[1]..Y2_Trans_Txt[13]]) THEN BEGIN // Charge Item Has not been Fetched already //2
                                if not (((charges.Description=Y2_Trans_Txt[1]) or (charges.Description=Y2_Trans_Txt[2])
                                or (charges.Description=Y2_Trans_Txt[3]) or (charges.Description=Y2_Trans_Txt[4])
                                or (charges.Description=Y2_Trans_Txt[5]) or (charges.Description=Y2_Trans_Txt[6])
                                or (charges.Description=Y2_Trans_Txt[7]) or (charges.Description=Y2_Trans_Txt[8])
                                or (charges.Description=Y2_Trans_Txt[9]) or (charges.Description=Y2_Trans_Txt[10])
                                or (charges.Description=Y2_Trans_Txt[11]) or (charges.Description=Y2_Trans_Txt[12])
                                or (charges.Description=Y2_Trans_Txt[13])))  then begin // Charge Item Has not been Fetched already //2
                                //
                                i2:=(CompressArray(Y2_Trans_Txt))+1;
                                Y2_Trans_Code[i2]:=stage_Charge.Code;
                                   Y2_Trans_Txt[i2]:=charges.Description;
                                   Y2S2_Trans_Val[i2]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[i2]:=Y2_Trans_Grand_Total[i2]+Y2S2_Trans_Val[i2];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[i2];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[i2];
                                end  //2
                                else begin//10 If the Item has notyet been picked
                                  if charges.Description = Y2_Trans_Txt[1] then begin
                                Y2_Trans_Code[1]:=stage_Charge.Code;
                                   Y2_Trans_Txt[1]:=charges.Description;
                                   Y2S2_Trans_Val[1]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[1]:=Y2_Trans_Grand_Total[1]+Y2S2_Trans_Val[1];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[1];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[1];
                                  end else if charges.Description = Y2_Trans_Txt[2] then begin
                                Y2_Trans_Code[2]:=stage_Charge.Code;
                                   Y2_Trans_Txt[2]:=charges.Description;
                                   Y2S2_Trans_Val[2]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[2]:=Y2_Trans_Grand_Total[2]+Y2S2_Trans_Val[2];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[2];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[2];
                                  end else if charges.Description = Y2_Trans_Txt[3] then begin
                                Y2_Trans_Code[3]:=stage_Charge.Code;
                                   Y2_Trans_Txt[3]:=charges.Description;
                                   Y2S2_Trans_Val[3]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[3]:=Y2_Trans_Grand_Total[3]+Y2S2_Trans_Val[3];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[3];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[3];

                                  end else if charges.Description = Y2_Trans_Txt[4] then begin
                                Y2_Trans_Code[4]:=stage_Charge.Code;
                                   Y2_Trans_Txt[4]:=charges.Description;
                                   Y2S2_Trans_Val[4]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[4]:=Y2_Trans_Grand_Total[4]+Y2S2_Trans_Val[4];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[4];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[4];

                                  end else if charges.Description = Y2_Trans_Txt[5] then begin
                                Y2_Trans_Code[5]:=stage_Charge.Code;
                                   Y2_Trans_Txt[5]:=charges.Description;
                                   Y2S2_Trans_Val[5]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[5]:=Y2_Trans_Grand_Total[5]+Y2S2_Trans_Val[5];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[5];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[5];

                                  end else if charges.Description = Y2_Trans_Txt[6] then begin
                                Y2_Trans_Code[6]:=stage_Charge.Code;
                                   Y2_Trans_Txt[6]:=charges.Description;
                                   Y2S2_Trans_Val[6]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[6]:=Y2_Trans_Grand_Total[6]+Y2S2_Trans_Val[6];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[6];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[6];

                                  end else if charges.Description = Y2_Trans_Txt[7] then begin
                                Y2_Trans_Code[7]:=stage_Charge.Code;
                                   Y2_Trans_Txt[7]:=charges.Description;
                                   Y2S2_Trans_Val[7]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[7]:=Y2_Trans_Grand_Total[7]+Y2S2_Trans_Val[7];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[7];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[7];

                                  end else if charges.Description = Y2_Trans_Txt[8] then begin
                                Y2_Trans_Code[8]:=stage_Charge.Code;
                                   Y2_Trans_Txt[8]:=charges.Description;
                                   Y2S2_Trans_Val[8]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[8]:=Y2_Trans_Grand_Total[8]+Y2S2_Trans_Val[8];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[8];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[8];

                                  end else if charges.Description = Y2_Trans_Txt[9] then begin
                                Y2_Trans_Code[9]:=stage_Charge.Code;
                                   Y2_Trans_Txt[9]:=charges.Description;
                                   Y2S2_Trans_Val[9]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[9]:=Y2_Trans_Grand_Total[9]+Y2S2_Trans_Val[9];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[9];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[9];

                                  end else if charges.Description = Y2_Trans_Txt[10] then begin
                                Y2_Trans_Code[10]:=stage_Charge.Code;
                                   Y2_Trans_Txt[10]:=charges.Description;
                                   Y2S2_Trans_Val[10]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[10]:=Y2_Trans_Grand_Total[10]+Y2S2_Trans_Val[10];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[10];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[10];

                                  end else if charges.Description = Y2_Trans_Txt[11] then begin
                                Y2_Trans_Code[11]:=stage_Charge.Code;
                                   Y2_Trans_Txt[11]:=charges.Description;
                                   Y2S2_Trans_Val[11]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[11]:=Y2_Trans_Grand_Total[11]+Y2S2_Trans_Val[11];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[11];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[11];

                                  end else if charges.Description = Y2_Trans_Txt[12] then begin
                                Y2_Trans_Code[12]:=stage_Charge.Code;
                                   Y2_Trans_Txt[12]:=charges.Description;
                                   Y2S2_Trans_Val[12]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[12]:=Y2_Trans_Grand_Total[12]+Y2S2_Trans_Val[12];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[12];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[12];

                                  end else if charges.Description = Y2_Trans_Txt[13] then begin
                                Y2_Trans_Code[13]:=stage_Charge.Code;
                                   Y2_Trans_Txt[13]:=charges.Description;
                                   Y2S2_Trans_Val[13]:=stage_Charge.Amount;
                                   Y2_Trans_Grand_Total[13]:=Y2_Trans_Grand_Total[13]+Y2S2_Trans_Val[13];
                                   Y2S2_Total:=Y2S2_Total+Y2S2_Trans_Val[13];
                                   Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Trans_Val[13];
                                end;
                                end;//10
                                end; // end for Y2S2 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y2S2
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y2S2');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y2S2_Tuit_Val:=FeeByStage."Break Down";
                                Y2_Tuit_Total_Val:=Y2_Tuit_Total_Val+Y2S2_Tuit_Val;
                                Y2S2_Total:=Y2S2_Total+Y2S2_Tuit_Val;
                                Y2_Grand_Total:=Y2_Grand_Total+Y2S2_Tuit_Val;
                              end; // 6

                              end;// 7
                            end; //5
                         //**************************************END Y2 END***********************************************//
                      end else if (CopyStr(progStages.Code,1,2)='Y3') then begin // Check if the stage is for 3rd Years
                     // clearVariables3();
                        if Y3='' then Y3:='ACADEMIC YEAR - 3RD YEAR STUDENTS';


                        Y3_ItemLabel:='ITEM';
                        Y3S1_Tuit_Caption:='FIRST';
                        Y3S2_Tuit_Caption:='SEMESTER';
                        Y3_Tuit_Total_Caption:='(KES)';
                        Y3S1_Tuit_Caption2:='SECOND';
                        Y3S2_Tuit_Caption2:='SEMESTER';
                        Y3_Tuit_Total_Caption2:='(KES)';
                        Y3S1_Tuit_Caption3:='TOTAL PER';
                        Y3S2_Tuit_Caption3:='YEAR';
                        Y3_Tuit_Total_Caption3:='(KES)';
                        Y3_Tuit_txt_lbl1:='A. TUITION: ';
                        Y3_Charges_txt_lbl2:='B. OTHER CHARGES: ';
                        Y3_Tuit_txt:='to be paid to the University';
                        Y3_Tuit_txt2:='on the registration day';
                        Y3_Charges_txt:='To bepaid to the ';
                        Y3_Charges_txt2:='University on the registration day';
                        Y3_Trans_txt_Footer:='TOTAL FEE PAYABLE TO KARATINA UNIVERSITY';
                        /// Fetch Charges and populate here
                        //********************************************Y3**************************************************//
                          // Fetch Charges per Stage for 1st Year 1st Sem Here
                            if progStages.Code = 'Y3S1' then begin //4
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y3S1');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y3S1 Charges Loop 1
                                // Charges for Y3S1 Exists
                                //Fetch Name for the charge
                                if charges.Get(stage_Charge.Code) then
                                if not ((charges.Description) in [Y3_Trans_Txt[1]..Y3_Trans_Txt[13]]) then begin // Charge Item Has not been Fetched already //2
                                //
                                i3:=CompressArray(Y3_Trans_Txt)+1;
                                Y3_Trans_Code[i3]:=stage_Charge.Code;
                                   Y3_Trans_Txt[i3]:=charges.Description;
                                   Y3S1_Trans_Val[i3]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[i3]:=Y3_Trans_Grand_Total[i3]+Y3S1_Trans_Val[i3];
                                   Y3S1_Total:=Y3S1_Total+Y3S1_Trans_Val[i3];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S1_Trans_Val[i3];
                                end; //2
                                end; // end for Y3S1 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y3S1
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y3S1');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y3S1_Tuit_Val:=FeeByStage."Break Down";
                                Y3_Tuit_Total_Val:=Y3_Tuit_Total_Val+Y3S1_Tuit_Val;
                                Y3S1_Total:=Y3S1_Total+Y3S1_Tuit_Val;
                                Y3_Grand_Total:=Y3_Grand_Total+Y3S1_Tuit_Val;
                              end; // 6
                            end else if progStages.Code = 'Y3S2' then begin // 4/5
                              Clear(counts);
                              begin // 7
                              counts:=counts+1;
                          // Fetch Charges per Stage for 1st Year 2nd sem Here
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              //stage_Charge.setrange(stage_Charge.Code,Y3_Trans_Code[counts]);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y3S2');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y3S2 Charges Loop 1
                                // Charges for Y3S2 Exists
                                //Fetch Name for the charge
                                //ERROR(Y3_Trans_Txt[1]+': '+Y3_Trans_Txt[2]);
                                if charges.Get(stage_Charge.Code) then
                                //IF NOT ((charges.Description) IN [Y3_Trans_Txt[1]..Y3_Trans_Txt[13]]) THEN BEGIN // Charge Item Has not been Fetched already //2
                                if not (((charges.Description=Y3_Trans_Txt[1]) or (charges.Description=Y3_Trans_Txt[2])
                                or (charges.Description=Y3_Trans_Txt[3]) or (charges.Description=Y3_Trans_Txt[4])
                                or (charges.Description=Y3_Trans_Txt[5]) or (charges.Description=Y3_Trans_Txt[6])
                                or (charges.Description=Y3_Trans_Txt[7]) or (charges.Description=Y3_Trans_Txt[8])
                                or (charges.Description=Y3_Trans_Txt[9]) or (charges.Description=Y3_Trans_Txt[10])
                                or (charges.Description=Y3_Trans_Txt[11]) or (charges.Description=Y3_Trans_Txt[12])
                                or (charges.Description=Y3_Trans_Txt[13])))  then begin // Charge Item Has not been Fetched already //2
                                //
                                i3:=(CompressArray(Y3_Trans_Txt))+1;
                                Y3_Trans_Code[i3]:=stage_Charge.Code;
                                   Y3_Trans_Txt[i3]:=charges.Description;
                                   Y3S2_Trans_Val[i3]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[i3]:=Y3_Trans_Grand_Total[i3]+Y3S2_Trans_Val[i3];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[i3];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[i3];
                                end  //2
                                else begin//10 If the Item has notyet been picked
                                  if charges.Description = Y3_Trans_Txt[1] then begin
                                Y3_Trans_Code[1]:=stage_Charge.Code;
                                   Y3_Trans_Txt[1]:=charges.Description;
                                   Y3S2_Trans_Val[1]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[1]:=Y3_Trans_Grand_Total[1]+Y3S2_Trans_Val[1];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[1];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[1];
                                  end else if charges.Description = Y3_Trans_Txt[2] then begin
                                Y3_Trans_Code[2]:=stage_Charge.Code;
                                   Y3_Trans_Txt[2]:=charges.Description;
                                   Y3S2_Trans_Val[2]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[2]:=Y3_Trans_Grand_Total[2]+Y3S2_Trans_Val[2];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[2];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[2];
                                  end else if charges.Description = Y3_Trans_Txt[3] then begin
                                Y3_Trans_Code[3]:=stage_Charge.Code;
                                   Y3_Trans_Txt[3]:=charges.Description;
                                   Y3S2_Trans_Val[3]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[3]:=Y3_Trans_Grand_Total[3]+Y3S2_Trans_Val[3];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[3];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[3];

                                  end else if charges.Description = Y3_Trans_Txt[4] then begin
                                Y3_Trans_Code[4]:=stage_Charge.Code;
                                   Y3_Trans_Txt[4]:=charges.Description;
                                   Y3S2_Trans_Val[4]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[4]:=Y3_Trans_Grand_Total[4]+Y3S2_Trans_Val[4];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[4];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[4];

                                  end else if charges.Description = Y3_Trans_Txt[5] then begin
                                Y3_Trans_Code[5]:=stage_Charge.Code;
                                   Y3_Trans_Txt[5]:=charges.Description;
                                   Y3S2_Trans_Val[5]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[5]:=Y3_Trans_Grand_Total[5]+Y3S2_Trans_Val[5];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[5];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[5];

                                  end else if charges.Description = Y3_Trans_Txt[6] then begin
                                Y3_Trans_Code[6]:=stage_Charge.Code;
                                   Y3_Trans_Txt[6]:=charges.Description;
                                   Y3S2_Trans_Val[6]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[6]:=Y3_Trans_Grand_Total[6]+Y3S2_Trans_Val[6];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[6];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[6];

                                  end else if charges.Description = Y3_Trans_Txt[7] then begin
                                Y3_Trans_Code[7]:=stage_Charge.Code;
                                   Y3_Trans_Txt[7]:=charges.Description;
                                   Y3S2_Trans_Val[7]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[7]:=Y3_Trans_Grand_Total[7]+Y3S2_Trans_Val[7];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[7];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[7];

                                  end else if charges.Description = Y3_Trans_Txt[8] then begin
                                Y3_Trans_Code[8]:=stage_Charge.Code;
                                   Y3_Trans_Txt[8]:=charges.Description;
                                   Y3S2_Trans_Val[8]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[8]:=Y3_Trans_Grand_Total[8]+Y3S2_Trans_Val[8];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[8];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[8];

                                  end else if charges.Description = Y3_Trans_Txt[9] then begin
                                Y3_Trans_Code[9]:=stage_Charge.Code;
                                   Y3_Trans_Txt[9]:=charges.Description;
                                   Y3S2_Trans_Val[9]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[9]:=Y3_Trans_Grand_Total[9]+Y3S2_Trans_Val[9];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[9];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[9];

                                  end else if charges.Description = Y3_Trans_Txt[10] then begin
                                Y3_Trans_Code[10]:=stage_Charge.Code;
                                   Y3_Trans_Txt[10]:=charges.Description;
                                   Y3S2_Trans_Val[10]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[10]:=Y3_Trans_Grand_Total[10]+Y3S2_Trans_Val[10];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[10];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[10];

                                  end else if charges.Description = Y3_Trans_Txt[11] then begin
                                Y3_Trans_Code[11]:=stage_Charge.Code;
                                   Y3_Trans_Txt[11]:=charges.Description;
                                   Y3S2_Trans_Val[11]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[11]:=Y3_Trans_Grand_Total[11]+Y3S2_Trans_Val[11];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[11];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[11];

                                  end else if charges.Description = Y3_Trans_Txt[12] then begin
                                Y3_Trans_Code[12]:=stage_Charge.Code;
                                   Y3_Trans_Txt[12]:=charges.Description;
                                   Y3S2_Trans_Val[12]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[12]:=Y3_Trans_Grand_Total[12]+Y3S2_Trans_Val[12];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[12];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[12];

                                  end else if charges.Description = Y3_Trans_Txt[13] then begin
                                Y3_Trans_Code[13]:=stage_Charge.Code;
                                   Y3_Trans_Txt[13]:=charges.Description;
                                   Y3S2_Trans_Val[13]:=stage_Charge.Amount;
                                   Y3_Trans_Grand_Total[13]:=Y3_Trans_Grand_Total[13]+Y3S2_Trans_Val[13];
                                   Y3S2_Total:=Y3S2_Total+Y3S2_Trans_Val[13];
                                   Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Trans_Val[13];
                                end;
                                end;//10
                                end; // end for Y3S2 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y3S2
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y3S2');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y3S2_Tuit_Val:=FeeByStage."Break Down";
                                Y3_Tuit_Total_Val:=Y3_Tuit_Total_Val+Y3S2_Tuit_Val;
                                Y3S2_Total:=Y3S2_Total+Y3S2_Tuit_Val;
                                Y3_Grand_Total:=Y3_Grand_Total+Y3S2_Tuit_Val;
                              end; // 6

                              end;// 7
                            end; //5
                         //**************************************END Y3 END***********************************************//
                      end else if (CopyStr(progStages.Code,1,2)='Y4') then begin // Check if the stage is for 4th Years
                      //clearVariables4();
                        if Y4='' then Y4:='ACADEMIC YEAR - 4TH YEAR STUDENTS';


                        Y4_ItemLabel:='ITEM';
                        Y4S1_Tuit_Caption:='FIRST';
                        Y4S2_Tuit_Caption:='SEMESTER';
                        Y4_Tuit_Total_Caption:='(KES)';
                        Y4S1_Tuit_Caption2:='SECOND';
                        Y4S2_Tuit_Caption2:='SEMESTER';
                        Y4_Tuit_Total_Caption2:='(KES)';
                        Y4S1_Tuit_Caption3:='TOTAL PER';
                        Y4S2_Tuit_Caption3:='YEAR';
                        Y4_Tuit_Total_Caption3:='(KES)';
                        Y4_Tuit_txt_lbl1:='A. TUITION: ';
                        Y4_Charges_txt_lbl2:='B. OTHER CHARGES: ';
                        Y4_Tuit_txt:='to be paid to the University';
                        Y4_Tuit_txt2:='on the registration day';
                        Y4_Charges_txt:='To bepaid to the ';
                        Y4_Charges_txt2:='University on the registration day';
                        Y4_Trans_txt_Footer:='TOTAL FEE PAYABLE TO KARATINA UNIVERSITY';
                        /// Fetch Charges and populate here
                        //********************************************Y4**************************************************//
                          // Fetch Charges per Stage for 1st Year 1st Sem Here
                            if progStages.Code = 'Y4S1' then begin //4
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y4S1');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y4S1 Charges Loop 1
                                // Charges for Y4S1 Exists
                                //Fetch Name for the charge
                                if charges.Get(stage_Charge.Code) then
                                if not ((charges.Description) in [Y4_Trans_Txt[1]..Y4_Trans_Txt[13]]) then begin // Charge Item Has not been Fetched already //2
                                //
                                i4:=CompressArray(Y4_Trans_Txt)+1;
                                Y4_Trans_Code[i4]:=stage_Charge.Code;
                                   Y4_Trans_Txt[i4]:=charges.Description;
                                   Y4S1_Trans_Val[i4]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[i4]:=Y4_Trans_Grand_Total[i4]+Y4S1_Trans_Val[i4];
                                   Y4S1_Total:=Y4S1_Total+Y4S1_Trans_Val[i4];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S1_Trans_Val[i4];
                                end; //2
                                end; // end for Y4S1 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y4S1
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y4S1');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y4S1_Tuit_Val:=FeeByStage."Break Down";
                                Y4_Tuit_Total_Val:=Y4_Tuit_Total_Val+Y4S1_Tuit_Val;
                                Y4S1_Total:=Y4S1_Total+Y4S1_Tuit_Val;
                                Y4_Grand_Total:=Y4_Grand_Total+Y4S1_Tuit_Val;
                              end; // 6
                            end else if progStages.Code = 'Y4S2' then begin // 4/5
                              Clear(counts);
                              begin // 7
                              counts:=counts+1;
                          // Fetch Charges per Stage for 1st Year 2nd sem Here
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              //stage_Charge.setrange(stage_Charge.Code,Y4_Trans_Code[counts]);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y4S2');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y4S2 Charges Loop 1
                                // Charges for Y4S2 Exists
                                //Fetch Name for the charge
                                //ERROR(Y4_Trans_Txt[1]+': '+Y4_Trans_Txt[2]);
                                if charges.Get(stage_Charge.Code) then
                                //IF NOT ((charges.Description) IN [Y4_Trans_Txt[1]..Y4_Trans_Txt[13]]) THEN BEGIN // Charge Item Has not been Fetched already //2
                                if not (((charges.Description=Y4_Trans_Txt[1]) or (charges.Description=Y4_Trans_Txt[2])
                                or (charges.Description=Y4_Trans_Txt[3]) or (charges.Description=Y4_Trans_Txt[4])
                                or (charges.Description=Y4_Trans_Txt[5]) or (charges.Description=Y4_Trans_Txt[6])
                                or (charges.Description=Y4_Trans_Txt[7]) or (charges.Description=Y4_Trans_Txt[8])
                                or (charges.Description=Y4_Trans_Txt[9]) or (charges.Description=Y4_Trans_Txt[10])
                                or (charges.Description=Y4_Trans_Txt[11]) or (charges.Description=Y4_Trans_Txt[12])
                                or (charges.Description=Y4_Trans_Txt[13])))  then begin // Charge Item Has not been Fetched already //2
                                //
                                i4:=(CompressArray(Y4_Trans_Txt))+1;
                                Y4_Trans_Code[i4]:=stage_Charge.Code;
                                   Y4_Trans_Txt[i4]:=charges.Description;
                                   Y4S2_Trans_Val[i4]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[i4]:=Y4_Trans_Grand_Total[i4]+Y4S2_Trans_Val[i4];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[i4];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[i4];
                                end  //2
                                else begin//10 If the Item has notyet been picked
                                  if charges.Description = Y4_Trans_Txt[1] then begin
                                Y4_Trans_Code[1]:=stage_Charge.Code;
                                   Y4_Trans_Txt[1]:=charges.Description;
                                   Y4S2_Trans_Val[1]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[1]:=Y4_Trans_Grand_Total[1]+Y4S2_Trans_Val[1];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[1];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[1];
                                  end else if charges.Description = Y4_Trans_Txt[2] then begin
                                Y4_Trans_Code[2]:=stage_Charge.Code;
                                   Y4_Trans_Txt[2]:=charges.Description;
                                   Y4S2_Trans_Val[2]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[2]:=Y4_Trans_Grand_Total[2]+Y4S2_Trans_Val[2];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[2];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[2];
                                  end else if charges.Description = Y4_Trans_Txt[3] then begin
                                Y4_Trans_Code[3]:=stage_Charge.Code;
                                   Y4_Trans_Txt[3]:=charges.Description;
                                   Y4S2_Trans_Val[3]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[3]:=Y4_Trans_Grand_Total[3]+Y4S2_Trans_Val[3];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[3];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[3];

                                  end else if charges.Description = Y4_Trans_Txt[4] then begin
                                Y4_Trans_Code[4]:=stage_Charge.Code;
                                   Y4_Trans_Txt[4]:=charges.Description;
                                   Y4S2_Trans_Val[4]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[4]:=Y4_Trans_Grand_Total[4]+Y4S2_Trans_Val[4];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[4];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[4];

                                  end else if charges.Description = Y4_Trans_Txt[5] then begin
                                Y4_Trans_Code[5]:=stage_Charge.Code;
                                   Y4_Trans_Txt[5]:=charges.Description;
                                   Y4S2_Trans_Val[5]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[5]:=Y4_Trans_Grand_Total[5]+Y4S2_Trans_Val[5];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[5];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[5];

                                  end else if charges.Description = Y4_Trans_Txt[6] then begin
                                Y4_Trans_Code[6]:=stage_Charge.Code;
                                   Y4_Trans_Txt[6]:=charges.Description;
                                   Y4S2_Trans_Val[6]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[6]:=Y4_Trans_Grand_Total[6]+Y4S2_Trans_Val[6];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[6];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[6];

                                  end else if charges.Description = Y4_Trans_Txt[7] then begin
                                Y4_Trans_Code[7]:=stage_Charge.Code;
                                   Y4_Trans_Txt[7]:=charges.Description;
                                   Y4S2_Trans_Val[7]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[7]:=Y4_Trans_Grand_Total[7]+Y4S2_Trans_Val[7];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[7];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[7];

                                  end else if charges.Description = Y4_Trans_Txt[8] then begin
                                Y4_Trans_Code[8]:=stage_Charge.Code;
                                   Y4_Trans_Txt[8]:=charges.Description;
                                   Y4S2_Trans_Val[8]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[8]:=Y4_Trans_Grand_Total[8]+Y4S2_Trans_Val[8];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[8];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[8];

                                  end else if charges.Description = Y4_Trans_Txt[9] then begin
                                Y4_Trans_Code[9]:=stage_Charge.Code;
                                   Y4_Trans_Txt[9]:=charges.Description;
                                   Y4S2_Trans_Val[9]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[9]:=Y4_Trans_Grand_Total[9]+Y4S2_Trans_Val[9];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[9];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[9];

                                  end else if charges.Description = Y4_Trans_Txt[10] then begin
                                Y4_Trans_Code[10]:=stage_Charge.Code;
                                   Y4_Trans_Txt[10]:=charges.Description;
                                   Y4S2_Trans_Val[10]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[10]:=Y4_Trans_Grand_Total[10]+Y4S2_Trans_Val[10];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[10];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[10];

                                  end else if charges.Description = Y4_Trans_Txt[11] then begin
                                Y4_Trans_Code[11]:=stage_Charge.Code;
                                   Y4_Trans_Txt[11]:=charges.Description;
                                   Y4S2_Trans_Val[11]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[11]:=Y4_Trans_Grand_Total[11]+Y4S2_Trans_Val[11];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[11];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[11];

                                  end else if charges.Description = Y4_Trans_Txt[12] then begin
                                Y4_Trans_Code[12]:=stage_Charge.Code;
                                   Y4_Trans_Txt[12]:=charges.Description;
                                   Y4S2_Trans_Val[12]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[12]:=Y4_Trans_Grand_Total[12]+Y4S2_Trans_Val[12];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[12];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[12];

                                  end else if charges.Description = Y4_Trans_Txt[13] then begin
                                Y4_Trans_Code[13]:=stage_Charge.Code;
                                   Y4_Trans_Txt[13]:=charges.Description;
                                   Y4S2_Trans_Val[13]:=stage_Charge.Amount;
                                   Y4_Trans_Grand_Total[13]:=Y4_Trans_Grand_Total[13]+Y4S2_Trans_Val[13];
                                   Y4S2_Total:=Y4S2_Total+Y4S2_Trans_Val[13];
                                   Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Trans_Val[13];
                                end;
                                end;//10
                                end; // end for Y4S2 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y4S2
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y4S2');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y4S2_Tuit_Val:=FeeByStage."Break Down";
                                Y4_Tuit_Total_Val:=Y4_Tuit_Total_Val+Y4S2_Tuit_Val;
                                Y4S2_Total:=Y4S2_Total+Y4S2_Tuit_Val;
                                Y4_Grand_Total:=Y4_Grand_Total+Y4S2_Tuit_Val;
                              end; // 6

                              end;// 7
                            end; //5
                         //**************************************END Y4 END***********************************************//
                      end else if (CopyStr(progStages.Code,1,2)='Y5') then begin // Check if the stage is for 5th Years
                       //clearVariables5();
                        if Y5='' then Y5:='ACADEMIC YEAR - 5TH YEAR STUDENTS';


                        Y5_ItemLabel:='ITEM';
                        Y5S1_Tuit_Caption:='FIRST';
                        Y5S2_Tuit_Caption:='SEMESTER';
                        Y5_Tuit_Total_Caption:='(KES)';
                        Y5S1_Tuit_Caption2:='SECOND';
                        Y5S2_Tuit_Caption2:='SEMESTER';
                        Y5_Tuit_Total_Caption2:='(KES)';
                        Y5S1_Tuit_Caption3:='TOTAL PER';
                        Y5S2_Tuit_Caption3:='YEAR';
                        Y5_Tuit_Total_Caption3:='(KES)';
                        Y5_Tuit_txt_lbl1:='A. TUITION: ';
                        Y5_Charges_txt_lbl2:='B. OTHER CHARGES: ';
                        Y5_Tuit_txt:='to be paid to the University';
                        Y5_Tuit_txt2:='on the registration day';
                        Y5_Charges_txt:='To bepaid to the ';
                        Y5_Charges_txt2:='University on the registration day';
                        Y5_Trans_txt_Footer:='TOTAL FEE PAYABLE TO KARATINA UNIVERSITY';
                        /// Fetch Charges and populate here
                        //********************************************Y5**************************************************//
                          // Fetch Charges per Stage for 1st Year 1st Sem Here
                            if progStages.Code = 'Y5S1' then begin //4
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y5S1');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y5S1 Charges Loop 1
                                // Charges for Y5S1 Exists
                                //Fetch Name for the charge
                                if charges.Get(stage_Charge.Code) then
                                if not ((charges.Description) in [Y5_Trans_Txt[1]..Y5_Trans_Txt[13]]) then begin // Charge Item Has not been Fetched already //2
                                //
                                i5:=CompressArray(Y5_Trans_Txt)+1;
                                Y5_Trans_Code[i5]:=stage_Charge.Code;
                                   Y5_Trans_Txt[i5]:=charges.Description;
                                   Y5S1_Trans_Val[i5]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[i5]:=Y5_Trans_Grand_Total[i5]+Y5S1_Trans_Val[i5];
                                   Y5S1_Total:=Y5S1_Total+Y5S1_Trans_Val[i5];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S1_Trans_Val[i5];
                                end; //2
                                end; // end for Y5S1 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y5S1
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y5S1');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y5S1_Tuit_Val:=FeeByStage."Break Down";
                                Y5_Tuit_Total_Val:=Y5_Tuit_Total_Val+Y5S1_Tuit_Val;
                                Y5S1_Total:=Y5S1_Total+Y5S1_Tuit_Val;
                                Y5_Grand_Total:=Y5_Grand_Total+Y5S1_Tuit_Val;
                              end; // 6
                            end else if progStages.Code = 'Y5S2' then begin // 4/5
                              Clear(counts);
                              begin // 7
                              counts:=counts+1;
                          // Fetch Charges per Stage for 1st Year 2nd sem Here
                              stage_Charge.Reset;
                              stage_Charge.SetRange(stage_Charge."Programme Code","ACA-Programme".Code);
                              stage_Charge.SetRange(stage_Charge."Settlement Type",Settlement_Type);
                              //stage_Charge.setrange(stage_Charge.Code,Y5_Trans_Code[counts]);
                              stage_Charge.SetFilter(stage_Charge."Stage Code",'Y5S2');
                               if stage_Charge.Find('-') then begin //3
                               repeat
                               begin // Begin for Y5S2 Charges Loop 1
                                // Charges for Y5S2 Exists
                                //Fetch Name for the charge
                                //ERROR(Y5_Trans_Txt[1]+': '+Y5_Trans_Txt[2]);
                                if charges.Get(stage_Charge.Code) then
                                //IF NOT ((charges.Description) IN [Y5_Trans_Txt[1]..Y5_Trans_Txt[13]]) THEN BEGIN // Charge Item Has not been Fetched already //2
                                if not (((charges.Description=Y5_Trans_Txt[1]) or (charges.Description=Y5_Trans_Txt[2])
                                or (charges.Description=Y5_Trans_Txt[3]) or (charges.Description=Y5_Trans_Txt[4])
                                or (charges.Description=Y5_Trans_Txt[5]) or (charges.Description=Y5_Trans_Txt[6])
                                or (charges.Description=Y5_Trans_Txt[7]) or (charges.Description=Y5_Trans_Txt[8])
                                or (charges.Description=Y5_Trans_Txt[9]) or (charges.Description=Y5_Trans_Txt[10])
                                or (charges.Description=Y5_Trans_Txt[11]) or (charges.Description=Y5_Trans_Txt[12])
                                or (charges.Description=Y5_Trans_Txt[13])))  then begin // Charge Item Has not been Fetched already //2
                                //
                                i5:=(CompressArray(Y5_Trans_Txt))+1;
                                Y5_Trans_Code[i5]:=stage_Charge.Code;
                                   Y5_Trans_Txt[i5]:=charges.Description;
                                   Y5S2_Trans_Val[i5]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[i5]:=Y5_Trans_Grand_Total[i5]+Y5S2_Trans_Val[i5];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[i5];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[i5];
                                end  //2
                                else begin//10 If the Item has notyet been picked
                                  if charges.Description = Y5_Trans_Txt[1] then begin
                                Y5_Trans_Code[1]:=stage_Charge.Code;
                                   Y5_Trans_Txt[1]:=charges.Description;
                                   Y5S2_Trans_Val[1]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[1]:=Y5_Trans_Grand_Total[1]+Y5S2_Trans_Val[1];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[1];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[1];
                                  end else if charges.Description = Y5_Trans_Txt[2] then begin
                                Y5_Trans_Code[2]:=stage_Charge.Code;
                                   Y5_Trans_Txt[2]:=charges.Description;
                                   Y5S2_Trans_Val[2]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[2]:=Y5_Trans_Grand_Total[2]+Y5S2_Trans_Val[2];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[2];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[2];
                                  end else if charges.Description = Y5_Trans_Txt[3] then begin
                                Y5_Trans_Code[3]:=stage_Charge.Code;
                                   Y5_Trans_Txt[3]:=charges.Description;
                                   Y5S2_Trans_Val[3]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[3]:=Y5_Trans_Grand_Total[3]+Y5S2_Trans_Val[3];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[3];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[3];

                                  end else if charges.Description = Y5_Trans_Txt[4] then begin
                                Y5_Trans_Code[4]:=stage_Charge.Code;
                                   Y5_Trans_Txt[4]:=charges.Description;
                                   Y5S2_Trans_Val[4]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[4]:=Y5_Trans_Grand_Total[4]+Y5S2_Trans_Val[4];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[4];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[4];

                                  end else if charges.Description = Y5_Trans_Txt[5] then begin
                                Y5_Trans_Code[5]:=stage_Charge.Code;
                                   Y5_Trans_Txt[5]:=charges.Description;
                                   Y5S2_Trans_Val[5]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[5]:=Y5_Trans_Grand_Total[5]+Y5S2_Trans_Val[5];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[5];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[5];

                                  end else if charges.Description = Y5_Trans_Txt[6] then begin
                                Y5_Trans_Code[6]:=stage_Charge.Code;
                                   Y5_Trans_Txt[6]:=charges.Description;
                                   Y5S2_Trans_Val[6]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[6]:=Y5_Trans_Grand_Total[6]+Y5S2_Trans_Val[6];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[6];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[6];

                                  end else if charges.Description = Y5_Trans_Txt[7] then begin
                                Y5_Trans_Code[7]:=stage_Charge.Code;
                                   Y5_Trans_Txt[7]:=charges.Description;
                                   Y5S2_Trans_Val[7]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[7]:=Y5_Trans_Grand_Total[7]+Y5S2_Trans_Val[7];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[7];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[7];

                                  end else if charges.Description = Y5_Trans_Txt[8] then begin
                                Y5_Trans_Code[8]:=stage_Charge.Code;
                                   Y5_Trans_Txt[8]:=charges.Description;
                                   Y5S2_Trans_Val[8]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[8]:=Y5_Trans_Grand_Total[8]+Y5S2_Trans_Val[8];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[8];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[8];

                                  end else if charges.Description = Y5_Trans_Txt[9] then begin
                                Y5_Trans_Code[9]:=stage_Charge.Code;
                                   Y5_Trans_Txt[9]:=charges.Description;
                                   Y5S2_Trans_Val[9]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[9]:=Y5_Trans_Grand_Total[9]+Y5S2_Trans_Val[9];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[9];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[9];

                                  end else if charges.Description = Y5_Trans_Txt[10] then begin
                                Y5_Trans_Code[10]:=stage_Charge.Code;
                                   Y5_Trans_Txt[10]:=charges.Description;
                                   Y5S2_Trans_Val[10]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[10]:=Y5_Trans_Grand_Total[10]+Y5S2_Trans_Val[10];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[10];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[10];

                                  end else if charges.Description = Y5_Trans_Txt[11] then begin
                                Y5_Trans_Code[11]:=stage_Charge.Code;
                                   Y5_Trans_Txt[11]:=charges.Description;
                                   Y5S2_Trans_Val[11]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[11]:=Y5_Trans_Grand_Total[11]+Y5S2_Trans_Val[11];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[11];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[11];

                                  end else if charges.Description = Y5_Trans_Txt[12] then begin
                                Y5_Trans_Code[12]:=stage_Charge.Code;
                                   Y5_Trans_Txt[12]:=charges.Description;
                                   Y5S2_Trans_Val[12]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[12]:=Y5_Trans_Grand_Total[12]+Y5S2_Trans_Val[12];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[12];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[12];

                                  end else if charges.Description = Y5_Trans_Txt[13] then begin
                                Y5_Trans_Code[13]:=stage_Charge.Code;
                                   Y5_Trans_Txt[13]:=charges.Description;
                                   Y5S2_Trans_Val[13]:=stage_Charge.Amount;
                                   Y5_Trans_Grand_Total[13]:=Y5_Trans_Grand_Total[13]+Y5S2_Trans_Val[13];
                                   Y5S2_Total:=Y5S2_Total+Y5S2_Trans_Val[13];
                                   Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Trans_Val[13];
                                end;
                                end;//10
                                end; // end for Y5S2 Charges Loop (Repeat)1
                                until stage_Charge.Next=0;
                                end;//3
                // Fetch Tuition Fees for Y5S2
                              FeeByStage.Reset;
                              FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme".Code);
                              FeeByStage.SetRange(FeeByStage."Stage Code",'Y5S2');
                              FeeByStage.SetRange(FeeByStage."Settlemet Type",Settlement_Type);
                              if FeeByStage.Find('-') then begin //6
                                Y5S2_Tuit_Val:=FeeByStage."Break Down";
                                Y5_Tuit_Total_Val:=Y5_Tuit_Total_Val+Y5S2_Tuit_Val;
                                Y5S2_Total:=Y5S2_Total+Y5S2_Tuit_Val;
                                Y5_Grand_Total:=Y5_Grand_Total+Y5S2_Tuit_Val;
                              end; // 6

                              end;// 7
                            end; //5
                         //**************************************END Y5 END***********************************************//
                      end;
                    end;
                  until progStages.Next=0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if ("ACA-Programme".GetFilter("ACA-Programme"."Settlement Type Filter"))='' then Error('The Settlement Type must have a value. \It cannot be zero or empty.');
                  Settlement_Type:=("ACA-Programme".GetFilter("ACA-Programme"."Settlement Type Filter"));
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
           if compInf.Get() then
            Settlement_Type:=compInf."Last Settlement Type";
           compInf.CalcFields(compInf.Picture);
    end;

    trigger OnPostReport()
    begin
          if Settlement_Type<>'' then
           if compInf.Get() then begin
            compInf."Last Settlement Type":=Settlement_Type;
            compInf.Modify;
            end;
    end;

    trigger OnPreReport()
    begin
           //  IF Settlement_Type='' THEN ERROR('The Settlement Type must have a value. \It cannot be zero or empty.');
    end;

    var
        compInf: Record "Company Information";
        FacultyName: Code[150];
        Y1: Code[150];
        Y1_ItemLabel: Code[30];
        Y1S1_Tuit_Caption: Code[100];
        Y1S2_Tuit_Caption: Code[100];
        Y1_Tuit_Total_Caption: Code[100];
        Y1S1_Tuit_Caption2: Code[100];
        Y1S2_Tuit_Caption2: Code[100];
        Y1_Tuit_Total_Caption2: Code[100];
        Y1S1_Tuit_Caption3: Code[100];
        Y1S2_Tuit_Caption3: Code[100];
        Y1_Tuit_Total_Caption3: Code[100];
        Y1S1_Tuit_Val: Decimal;
        Y1S2_Tuit_Val: Decimal;
        Y1_Tuit_Total_Val: Decimal;
        Y1_Tuit_txt_lbl1: Code[30];
        Y1_Charges_txt_lbl2: Code[30];
        Y1_Tuit_txt: Text[100];
        Y1_Tuit_txt2: Text[100];
        Y1_Charges_txt: Text[100];
        Y1_Charges_txt2: Text[100];
        Y1_Trans_txt_Footer: Code[100];
        Y1S1_Total: Decimal;
        Y1S2_Total: Decimal;
        Y1_Grand_Total: Decimal;
        Y1_Trans_Txt: array [20] of Text[100];
        Y1S1_Trans_Val: array [20] of Decimal;
        Y1S2_Trans_Val: array [20] of Decimal;
        Y1_Trans_Grand_Total: array [20] of Decimal;
        Y1_Trans_Code: array [20] of Code[100];
        counts: Integer;
        Settlement_Type: Code[30];
        i1: Integer;
        charges: Record UnknownRecord61515;
        stage_Charge: Record UnknownRecord61533;
        progStages: Record UnknownRecord61516;
        FeeByStage: Record UnknownRecord61523;
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 2": Integer;
        Y2: Code[150];
        Y2_ItemLabel: Code[30];
        Y2S1_Tuit_Caption: Code[100];
        Y2S2_Tuit_Caption: Code[100];
        Y2_Tuit_Total_Caption: Code[100];
        Y2S1_Tuit_Caption2: Code[100];
        Y2S2_Tuit_Caption2: Code[100];
        Y2_Tuit_Total_Caption2: Code[100];
        Y2S1_Tuit_Caption3: Code[100];
        Y2S2_Tuit_Caption3: Code[100];
        Y2_Tuit_Total_Caption3: Code[100];
        Y2S1_Tuit_Val: Decimal;
        Y2S2_Tuit_Val: Decimal;
        Y2_Tuit_Total_Val: Decimal;
        Y2_Tuit_txt_lbl1: Code[30];
        Y2_Charges_txt_lbl2: Code[30];
        Y2_Tuit_txt: Text[100];
        Y2_Tuit_txt2: Text[100];
        Y2_Charges_txt: Text[100];
        Y2_Charges_txt2: Text[100];
        Y2_Trans_txt_Footer: Code[100];
        Y2S1_Total: Decimal;
        Y2S2_Total: Decimal;
        Y2_Grand_Total: Decimal;
        Y2_Trans_Txt: array [20] of Text[100];
        Y2S1_Trans_Val: array [20] of Decimal;
        Y2S2_Trans_Val: array [20] of Decimal;
        Y2_Trans_Grand_Total: array [20] of Decimal;
        Y2_Trans_Code: array [20] of Code[100];
        i2: Integer;
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 3": Integer;
        Y3: Code[150];
        Y3_ItemLabel: Code[30];
        Y3S1_Tuit_Caption: Code[100];
        Y3S2_Tuit_Caption: Code[100];
        Y3_Tuit_Total_Caption: Code[100];
        Y3S1_Tuit_Caption2: Code[100];
        Y3S2_Tuit_Caption2: Code[100];
        Y3_Tuit_Total_Caption2: Code[100];
        Y3S1_Tuit_Caption3: Code[100];
        Y3S2_Tuit_Caption3: Code[100];
        Y3_Tuit_Total_Caption3: Code[100];
        Y3S1_Tuit_Val: Decimal;
        Y3S2_Tuit_Val: Decimal;
        Y3_Tuit_Total_Val: Decimal;
        Y3_Tuit_txt_lbl1: Code[30];
        Y3_Charges_txt_lbl2: Code[30];
        Y3_Tuit_txt: Text[100];
        Y3_Tuit_txt2: Text[100];
        Y3_Charges_txt: Text[100];
        Y3_Charges_txt2: Text[100];
        Y3_Trans_txt_Footer: Code[100];
        Y3S1_Total: Decimal;
        Y3S2_Total: Decimal;
        Y3_Grand_Total: Decimal;
        Y3_Trans_Txt: array [20] of Text[100];
        Y3S1_Trans_Val: array [20] of Decimal;
        Y3S2_Trans_Val: array [20] of Decimal;
        Y3_Trans_Grand_Total: array [20] of Decimal;
        Y3_Trans_Code: array [20] of Code[100];
        i3: Integer;
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 4": Integer;
        Y4: Code[150];
        Y4_ItemLabel: Code[30];
        Y4S1_Tuit_Caption: Code[100];
        Y4S2_Tuit_Caption: Code[100];
        Y4_Tuit_Total_Caption: Code[100];
        Y4S1_Tuit_Caption2: Code[100];
        Y4S2_Tuit_Caption2: Code[100];
        Y4_Tuit_Total_Caption2: Code[100];
        Y4S1_Tuit_Caption3: Code[100];
        Y4S2_Tuit_Caption3: Code[100];
        Y4_Tuit_Total_Caption3: Code[100];
        Y4S1_Tuit_Val: Decimal;
        Y4S2_Tuit_Val: Decimal;
        Y4_Tuit_Total_Val: Decimal;
        Y4_Tuit_txt_lbl1: Code[30];
        Y4_Charges_txt_lbl2: Code[30];
        Y4_Tuit_txt: Text[100];
        Y4_Tuit_txt2: Text[100];
        Y4_Charges_txt: Text[100];
        Y4_Charges_txt2: Text[100];
        Y4_Trans_txt_Footer: Code[100];
        Y4S1_Total: Decimal;
        Y4S2_Total: Decimal;
        Y4_Grand_Total: Decimal;
        Y4_Trans_Txt: array [20] of Text[100];
        Y4S1_Trans_Val: array [20] of Decimal;
        Y4S2_Trans_Val: array [20] of Decimal;
        Y4_Trans_Grand_Total: array [20] of Decimal;
        Y4_Trans_Code: array [20] of Code[100];
        i4: Integer;
        "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx 5": Integer;
        Y5: Code[150];
        Y5_ItemLabel: Code[30];
        Y5S1_Tuit_Caption: Code[100];
        Y5S2_Tuit_Caption: Code[100];
        Y5_Tuit_Total_Caption: Code[100];
        Y5S1_Tuit_Caption2: Code[100];
        Y5S2_Tuit_Caption2: Code[100];
        Y5_Tuit_Total_Caption2: Code[100];
        Y5S1_Tuit_Caption3: Code[100];
        Y5S2_Tuit_Caption3: Code[100];
        Y5_Tuit_Total_Caption3: Code[100];
        Y5S1_Tuit_Val: Decimal;
        Y5S2_Tuit_Val: Decimal;
        Y5_Tuit_Total_Val: Decimal;
        Y5_Tuit_txt_lbl1: Code[30];
        Y5_Charges_txt_lbl2: Code[30];
        Y5_Tuit_txt: Text[100];
        Y5_Tuit_txt2: Text[100];
        Y5_Charges_txt: Text[100];
        Y5_Charges_txt2: Text[100];
        Y5_Trans_txt_Footer: Code[100];
        Y5S1_Total: Decimal;
        Y5S2_Total: Decimal;
        Y5_Grand_Total: Decimal;
        Y5_Trans_Txt: array [20] of Text[100];
        Y5S1_Trans_Val: array [20] of Decimal;
        Y5S2_Trans_Val: array [20] of Decimal;
        Y5_Trans_Grand_Total: array [20] of Decimal;
        Y5_Trans_Code: array [20] of Code[100];
        i5: Integer;

    local procedure clearVariables1()
    begin
            Clear(Y1);
            Clear(Y1_ItemLabel);
            Clear(Y1S1_Tuit_Caption);
            Clear(Y1S2_Tuit_Caption);
            Clear(Y1_Tuit_Total_Caption);
            Clear(Y1S1_Tuit_Val);
            Clear(Y1S2_Tuit_Val);
            Clear(Y1_Tuit_Total_Val);
            Clear(Y1_Tuit_txt_lbl1);
            Clear(Y1_Charges_txt_lbl2);
            Clear(Y1_Tuit_txt);
            Clear(Y1_Tuit_txt2);
            Clear(Y1_Charges_txt);
            Clear(Y1_Charges_txt2);
            Clear(Y1_Trans_txt_Footer);
            Clear(Y1S1_Total);
            Clear(Y1S2_Total);
            Clear(Y1_Grand_Total);
            Clear(Y1_Trans_Txt);
            Clear(Y1S1_Trans_Val);
            Clear(Y1S2_Trans_Val);
            Clear(Y1_Trans_Grand_Total);
            Clear(i1);
            Clear(Y1S1_Tuit_Caption2);
            Clear(Y1S2_Tuit_Caption2);
            Clear(Y1_Tuit_Total_Caption2);
            Clear(Y1S1_Tuit_Caption3);
            Clear(Y1S2_Tuit_Caption3);
            Clear(Y1_Tuit_Total_Caption3);
            Clear(Y1_Trans_Code);
    end;

    local procedure clearVariables2()
    begin

            Clear(Y2);
            Clear(Y2_ItemLabel);
            Clear(Y2S1_Tuit_Caption);
            Clear(Y2S2_Tuit_Caption);
            Clear(Y2_Tuit_Total_Caption);
            Clear(Y2S1_Tuit_Val);
            Clear(Y2S2_Tuit_Val);
            Clear(Y2_Tuit_Total_Val);
            Clear(Y2_Tuit_txt_lbl1);
            Clear(Y2_Charges_txt_lbl2);
            Clear(Y2_Tuit_txt);
            Clear(Y2_Tuit_txt2);
            Clear(Y2_Charges_txt);
            Clear(Y2_Charges_txt2);
            Clear(Y2_Trans_txt_Footer);
            Clear(Y2S1_Total);
            Clear(Y2S2_Total);
            Clear(Y2_Grand_Total);
            Clear(Y2_Trans_Txt);
            Clear(Y2S1_Trans_Val);
            Clear(Y2S2_Trans_Val);
            Clear(Y2_Trans_Grand_Total);
            Clear(i2);
            Clear(Y2S1_Tuit_Caption2);
            Clear(Y2S2_Tuit_Caption2);
            Clear(Y2_Tuit_Total_Caption2);
            Clear(Y2S1_Tuit_Caption3);
            Clear(Y2S2_Tuit_Caption3);
            Clear(Y2_Tuit_Total_Caption3);
            Clear(Y2_Trans_Code);
    end;

    local procedure clearVariables3()
    begin

            Clear(Y3);
            Clear(Y3_ItemLabel);
            Clear(Y3S1_Tuit_Caption);
            Clear(Y3S2_Tuit_Caption);
            Clear(Y3_Tuit_Total_Caption);
            Clear(Y3S1_Tuit_Val);
            Clear(Y3S2_Tuit_Val);
            Clear(Y3_Tuit_Total_Val);
            Clear(Y3_Tuit_txt_lbl1);
            Clear(Y3_Charges_txt_lbl2);
            Clear(Y3_Tuit_txt);
            Clear(Y3_Tuit_txt2);
            Clear(Y3_Charges_txt);
            Clear(Y3_Charges_txt2);
            Clear(Y3_Trans_txt_Footer);
            Clear(Y3S1_Total);
            Clear(Y3S2_Total);
            Clear(Y3_Grand_Total);
            Clear(Y3_Trans_Txt);
            Clear(Y3S1_Trans_Val);
            Clear(Y3S2_Trans_Val);
            Clear(Y3_Trans_Grand_Total);
            Clear(i3);
            Clear(Y3S1_Tuit_Caption2);
            Clear(Y3S2_Tuit_Caption2);
            Clear(Y3_Tuit_Total_Caption2);
            Clear(Y3S1_Tuit_Caption3);
            Clear(Y3S2_Tuit_Caption3);
            Clear(Y3_Tuit_Total_Caption3);
            Clear(Y3_Trans_Code);
    end;

    local procedure clearVariables4()
    begin

            Clear(Y4);
            Clear(Y4_ItemLabel);
            Clear(Y4S1_Tuit_Caption);
            Clear(Y4S2_Tuit_Caption);
            Clear(Y4_Tuit_Total_Caption);
            Clear(Y4S1_Tuit_Val);
            Clear(Y4S2_Tuit_Val);
            Clear(Y4_Tuit_Total_Val);
            Clear(Y4_Tuit_txt_lbl1);
            Clear(Y4_Charges_txt_lbl2);
            Clear(Y4_Tuit_txt);
            Clear(Y4_Tuit_txt2);
            Clear(Y4_Charges_txt);
            Clear(Y4_Charges_txt2);
            Clear(Y4_Trans_txt_Footer);
            Clear(Y4S1_Total);
            Clear(Y4S2_Total);
            Clear(Y4_Grand_Total);
            Clear(Y4_Trans_Txt);
            Clear(Y4S1_Trans_Val);
            Clear(Y4S2_Trans_Val);
            Clear(Y4_Trans_Grand_Total);
            Clear(i4);
            Clear(Y4S1_Tuit_Caption2);
            Clear(Y4S2_Tuit_Caption2);
            Clear(Y4_Tuit_Total_Caption2);
            Clear(Y4S1_Tuit_Caption3);
            Clear(Y4S2_Tuit_Caption3);
            Clear(Y4_Tuit_Total_Caption3);
            Clear(Y4_Trans_Code);
    end;

    local procedure clearVariables5()
    begin

            Clear(Y5);
            Clear(Y5_ItemLabel);
            Clear(Y5S1_Tuit_Caption);
            Clear(Y5S2_Tuit_Caption);
            Clear(Y5_Tuit_Total_Caption);
            Clear(Y5S1_Tuit_Val);
            Clear(Y5S2_Tuit_Val);
            Clear(Y5_Tuit_Total_Val);
            Clear(Y5_Tuit_txt_lbl1);
            Clear(Y5_Charges_txt_lbl2);
            Clear(Y5_Tuit_txt);
            Clear(Y5_Tuit_txt2);
            Clear(Y5_Charges_txt);
            Clear(Y5_Charges_txt2);
            Clear(Y5_Trans_txt_Footer);
            Clear(Y5S1_Total);
            Clear(Y5S2_Total);
            Clear(Y5_Grand_Total);
            Clear(Y5_Trans_Txt);
            Clear(Y5S1_Trans_Val);
            Clear(Y5S2_Trans_Val);
            Clear(Y5_Trans_Grand_Total);
            Clear(i5);
            Clear(Y5S1_Tuit_Caption2);
            Clear(Y5S2_Tuit_Caption2);
            Clear(Y5_Tuit_Total_Caption2);
            Clear(Y5S1_Tuit_Caption3);
            Clear(Y5S2_Tuit_Caption3);
            Clear(Y5_Tuit_Total_Caption3);
            Clear(Y5_Trans_Code);
    end;
}

