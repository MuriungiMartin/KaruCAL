#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78068 "ACA-Results Buffer Students"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable78065;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Fee Balance";"Fee Balance")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                }
                field(Unit1;"Unit 1 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[1];
                    Editable = false;
                    Visible = UnitVisible_1;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[1] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[1],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit2;"Unit 2 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[2];
                    Editable = false;
                    Visible = UnitVisible_2;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[2] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[2],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit3;"Unit 3 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[3];
                    Editable = false;
                    Visible = UnitVisible_3;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[3] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[3],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit4;"Unit 4 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[4];
                    Editable = false;
                    Visible = UnitVisible_4;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[4] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[4],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit5;"Unit 5 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[5];
                    Editable = false;
                    Visible = UnitVisible_5;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[5] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[5],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit6;"Unit 6 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[6];
                    Editable = false;
                    Visible = UnitVisible_6;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[6] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[6],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit7;"Unit 7 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[7];
                    Editable = false;
                    Visible = UnitVisible_7;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[7] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[7],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit8;"Unit 8 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[8];
                    Editable = false;
                    Visible = UnitVisible_8;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[8] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[8],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit9;"Unit 9 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[9];
                    Editable = false;
                    Visible = UnitVisible_9;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[9] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[9],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit10;"Unit 10 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[10];
                    Editable = false;
                    Visible = UnitVisible_10;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[10] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[10],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit11;"Unit 11 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[11];
                    Editable = false;
                    Visible = UnitVisible_11;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[11] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[11],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit12;"Unit 12 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[12];
                    Editable = false;
                    Visible = UnitVisible_12;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[12] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[12],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit13;"Unit 13 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[13];
                    Editable = false;
                    Visible = UnitVisible_13;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[13] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[13],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit14;"Unit 14 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[14];
                    Editable = false;
                    Visible = UnitVisible_14;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[14] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[14],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit15;"Unit 15 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[15];
                    Editable = false;
                    Visible = UnitVisible_15;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[15] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[15],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit16;"Unit 16 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[16];
                    Editable = false;
                    Visible = UnitVisible_16;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[16] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[16],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit17;"Unit 17 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[17];
                    Editable = false;
                    Visible = UnitVisible_17;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[17] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[17],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit18;"Unit 18 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[18];
                    Editable = false;
                    Visible = UnitVisible_18;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[18] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[18],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit19;"Unit 19 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[19];
                    Editable = false;
                    Visible = UnitVisible_19;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[19] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[19],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit20;"Unit 20 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[20];
                    Editable = false;
                    Visible = UnitVisible_20;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[20] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[20],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit21;"Unit 21 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[21];
                    Editable = false;
                    Visible = UnitVisible_21;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[21] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[21],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit22;"Unit 22 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[22];
                    Editable = false;
                    Visible = UnitVisible_22;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[22] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[22],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit23;"Unit 23 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[23];
                    Editable = false;
                    Visible = UnitVisible_23;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[23] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[23],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit24;"Unit 24 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[24];
                    Editable = false;
                    Visible = UnitVisible_24;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[24] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[24],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit25;"Unit 25 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[25];
                    Editable = false;
                    Visible = UnitVisible_25;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[25] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[25],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit26;"Unit 26 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[26];
                    Editable = false;
                    Visible = UnitVisible_26;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[26] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[26],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit27;"Unit 27 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[27];
                    Editable = false;
                    Visible = UnitVisible_27;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[27] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[27],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit28;"Unit 28 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[28];
                    Editable = false;
                    Visible = UnitVisible_28;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[28] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[28],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit29;"Unit 29 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[29];
                    Editable = false;
                    Visible = UnitVisible_29;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[29] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[29],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit30;"Unit 30 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[30];
                    Editable = false;
                    Visible = UnitVisible_30;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[30] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[30],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit31;"Unit 31 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[31];
                    Editable = false;
                    Visible = UnitVisible_31;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[31] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[31],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit32;"Unit 32 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[32];
                    Editable = false;
                    Visible = UnitVisible_32;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[32] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[32],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit33;"Unit 33 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[33];
                    Editable = false;
                    Visible = UnitVisible_33;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[33] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[33],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit34;"Unit 34 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[34];
                    Editable = false;
                    Visible = UnitVisible_34;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[34] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[34],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit35;"Unit 35 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[35];
                    Editable = false;
                    Visible = UnitVisible_35;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[35] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[35],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit36;"Unit 36 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[36];
                    Editable = false;
                    Visible = UnitVisible_36;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[36] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[36],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit37;"Unit 37 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[37];
                    Editable = false;
                    Visible = UnitVisible_37;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[37] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[37],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit38;"Unit 38 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[38];
                    Editable = false;
                    Visible = UnitVisible_38;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[38] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[38],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit39;"Unit 39 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[39];
                    Editable = false;
                    Visible = UnitVisible_39;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[39] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[39],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit40;"Unit 40 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[40];
                    Editable = false;
                    Visible = UnitVisible_40;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[40] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[40],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit41;"Unit 41 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[41];
                    Editable = false;
                    Visible = UnitVisible_41;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[41] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[41],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit42;"Unit 42 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[42];
                    Editable = false;
                    Visible = UnitVisible_42;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[42] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[42],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit43;"Unit 43 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[43];
                    Editable = false;
                    Visible = UnitVisible_43;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[43] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[43],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit44;"Unit 44 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[44];
                    Editable = false;
                    Visible = UnitVisible_44;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[44] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[44],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit45;"Unit 45 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[45];
                    Editable = false;
                    Visible = UnitVisible_45;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[45] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[45],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit46;"Unit 46 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[46];
                    Editable = false;
                    Visible = UnitVisible_46;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[46] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[46],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit47;"Unit 47 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[47];
                    Editable = false;
                    Visible = UnitVisible_47;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[47] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[47],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit48;"Unit 48 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[48];
                    Editable = false;
                    Visible = UnitVisible_48;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[48] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[48],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit49;"Unit 49 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[49];
                    Editable = false;
                    Visible = UnitVisible_49;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[49] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[49],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit50;"Unit 50 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[50];
                    Editable = false;
                    Visible = UnitVisible_50;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[50] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[50],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit51;"Unit 51 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[51];
                    Editable = false;
                    Visible = UnitVisible_51;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[51] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[51],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit52;"Unit 52 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[52];
                    Editable = false;
                    Visible = UnitVisible_52;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[52] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[52],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit53;"Unit 53 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[53];
                    Editable = false;
                    Visible = UnitVisible_53;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[53] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[53],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit54;"Unit 54 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[54];
                    Editable = false;
                    Visible = UnitVisible_5;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[54] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[54],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit55;"Unit 55 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[55];
                    Editable = false;
                    Visible = UnitVisible_55;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[55] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[55],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit56;"Unit 56 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[56];
                    Editable = false;
                    Visible = UnitVisible_56;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[56] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[56],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit57;"Unit 57 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[57];
                    Editable = false;
                    Visible = UnitVisible_57;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[57] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[57],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit58;"Unit 58 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[58];
                    Editable = false;
                    Visible = UnitVisible_58;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[58] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[58],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit59;"Unit 59 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[59];
                    Editable = false;
                    Visible = UnitVisible_59;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[59] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[59],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit60;"Unit 60 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[60];
                    Editable = false;
                    Visible = UnitVisible_60;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[60] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[60],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit61;"Unit 61 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[61];
                    Editable = false;
                    Visible = UnitVisible_61;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[61] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[61],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit62;"Unit 62 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[62];
                    Editable = false;
                    Visible = UnitVisible_62;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[62] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[62],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit63;"Unit 63 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[63];
                    Editable = false;
                    Visible = UnitVisible_63;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[63] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[63],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit64;"Unit 64 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[64];
                    Editable = false;
                    Visible = UnitVisible_64;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[64] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[64],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit65;"Unit 65 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[65];
                    Editable = false;
                    Visible = UnitVisible_65;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[65] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[65],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit66;"Unit 66 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[66];
                    Editable = false;
                    Visible = UnitVisible_66;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[66] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[66],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit67;"Unit 67 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[67];
                    Editable = false;
                    Visible = UnitVisible_67;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[67] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[67],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field(Unit68;"Unit 68 Score")
                {
                    ApplicationArea = Basic;
                    CaptionClass = '3,'+CaptionArrays[68];
                    Editable = false;
                    Visible = UnitVisible_68;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if CaptionArrays[68] <> '' then ShowUnitDetails(Rec.Programme,CaptionArrays[68],Rec."Student No.",Rec."Academic Year",Rec.Semester);
                    end;
                }
                field("Total Marks";"Total Marks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Units Count";"Total Units Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Exam Category";"Exam Category")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Average Score";"Average Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Average Grade";"Average Grade")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Rubric;Rubric)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        Loops: Integer;
    begin

        ///////////////////
        // // // // // CLEAR(Loops);
        // // // // // BEGIN
        // // // // // REPEAT
        // // // // //  BEGIN
        // // // // //  Loops := Loops+1;
        // // // // //  CLEAR(UnitScores);
        // // // // // IF CaptionArrays[Loops] <> '' THEN BEGIN
        // // // // //  CLEAR(ACAResultsBufferDetails);
        // // // // //  ACAResultsBufferDetails.RESET;
        // // // // //  ACAResultsBufferDetails.SETRANGE("Academic Year",Rec."Academic Year");
        // // // // //  ACAResultsBufferDetails.SETRANGE(Semester,Rec.Semester);
        // // // // //  ACAResultsBufferDetails.SETRANGE(Programme,Rec.Programme);
        // // // // //  ACAResultsBufferDetails.SETRANGE("Unit Code",CaptionArrays[Loops]);
        // // // // //  ACAResultsBufferDetails.SETRANGE("Student No.",Rec."Student No.");
        // // // // //  IF ACAResultsBufferDetails.FIND('-') THEN BEGIN
        // // // // //    REPEAT
        // // // // //      ACAResultsBufferDetails.CALCFIELDS("Total Score");
        // // // // //      UnitScores[Loops] := "Total Score";
        // // // // //      UNTIL ACAResultsBufferDetails.NEXT = 0;
        // // // // //    END;
        // // // // //  END;
        // // // // //  END;
        // // // // //  UNTIL Loops = Recounts;
        // // // // //  END;
    end;

    trigger OnOpenPage()
    begin
        Clear(HeadersUpdated);
        UnitVisible_1 := false;
        ////////
        if HeadersUpdated = false then begin
        Clear(ProgFilters);
        Clear(AcadYearFilters);
        Clear(SemFilters);
        Clear(ACAResultMatrixFilters);
        ACAResultMatrixFilters.Reset;
        ACAResultMatrixFilters.SetRange("User-Id",UserId);
        if ACAResultMatrixFilters.Find('-') then;
        ProgFilters := ACAResultMatrixFilters.Programme;
        AcadYearFilters := ACAResultMatrixFilters."Academic Year";
        SemFilters := ACAResultMatrixFilters.Semester;
        Clear(CaptionArrays);
        Clear(UnitScores);
        Clear(Recounts);
        Clear(ACAResultsBufferUnits);
        ACAResultsBufferUnits.Reset;
        ACAResultsBufferUnits.SetRange("Academic Year",AcadYearFilters);
        ACAResultsBufferUnits.SetRange(Programme,ProgFilters);
        ACAResultsBufferUnits.SetRange(Semester,SemFilters);
        if ACAResultsBufferUnits.Find('-') then begin
        repeat
        begin
         Recounts := Recounts +1;
        CaptionArrays[Recounts] := ACAResultsBufferUnits."Unit Code";
        if Recounts = 1  then UnitVisible_1 := true;
        if Recounts = 2  then UnitVisible_2 := true;
        if Recounts = 3  then UnitVisible_3 := true;
        if Recounts = 4  then UnitVisible_4 := true;
        if Recounts = 5  then UnitVisible_5 := true;
        if Recounts = 6  then UnitVisible_6 := true;
        if Recounts = 7  then UnitVisible_7 := true;
        if Recounts = 8  then UnitVisible_8 := true;
        if Recounts = 9  then UnitVisible_9 := true;
        if Recounts = 10  then UnitVisible_10 := true;
        if Recounts = 11  then UnitVisible_11 := true;
        if Recounts = 12  then UnitVisible_12 := true;
        if Recounts = 13  then UnitVisible_13 := true;
        if Recounts = 14  then UnitVisible_14 := true;
        if Recounts = 15  then UnitVisible_15 := true;
        if Recounts = 16  then UnitVisible_16 := true;
        if Recounts = 17  then UnitVisible_17 := true;
        if Recounts = 18  then UnitVisible_18 := true;
        if Recounts = 19  then UnitVisible_19 := true;
        if Recounts = 20  then UnitVisible_20 := true;
        if Recounts = 21  then UnitVisible_21 := true;
        if Recounts = 22  then UnitVisible_22 := true;
        if Recounts = 23  then UnitVisible_23 := true;
        if Recounts = 24  then UnitVisible_24 := true;
        if Recounts = 25  then UnitVisible_25 := true;
        if Recounts = 26  then UnitVisible_26 := true;
        if Recounts = 27  then UnitVisible_27 := true;
        if Recounts = 28  then UnitVisible_28 := true;
        if Recounts = 29  then UnitVisible_29 := true;
        if Recounts = 30  then UnitVisible_30 := true;
        if Recounts = 31  then UnitVisible_31 := true;
        if Recounts = 32  then UnitVisible_32 := true;
        if Recounts = 33  then UnitVisible_33 := true;
        if Recounts = 34  then UnitVisible_34 := true;
        if Recounts = 35  then UnitVisible_35 := true;
        if Recounts = 36  then UnitVisible_36 := true;
        if Recounts = 37  then UnitVisible_37 := true;
        if Recounts = 38  then UnitVisible_38 := true;
        if Recounts = 39  then UnitVisible_39 := true;
        if Recounts = 40  then UnitVisible_40 := true;
        if Recounts = 41  then UnitVisible_41 := true;
        if Recounts = 42  then UnitVisible_42 := true;
        if Recounts = 43  then UnitVisible_43 := true;
        if Recounts = 44  then UnitVisible_44 := true;
        if Recounts = 45  then UnitVisible_45 := true;
        if Recounts = 46  then UnitVisible_46 := true;
        if Recounts = 47  then UnitVisible_47 := true;
        if Recounts = 48  then UnitVisible_48 := true;
        if Recounts = 49  then UnitVisible_49 := true;
        if Recounts = 50  then UnitVisible_50 := true;
        if Recounts = 51  then UnitVisible_51 := true;
        if Recounts = 52  then UnitVisible_52 := true;
        if Recounts = 53  then UnitVisible_53 := true;
        if Recounts = 54  then UnitVisible_54 := true;
        if Recounts = 55  then UnitVisible_55 := true;
        if Recounts = 56  then UnitVisible_56 := true;
        if Recounts = 57  then UnitVisible_57 := true;
        if Recounts = 58  then UnitVisible_58 := true;
        if Recounts = 59  then UnitVisible_59 := true;
        if Recounts = 60  then UnitVisible_60 := true;
        if Recounts = 61  then UnitVisible_61 := true;
        if Recounts = 62  then UnitVisible_62 := true;
        if Recounts = 63  then UnitVisible_63 := true;
        if Recounts = 64  then UnitVisible_64 := true;
        if Recounts = 65  then UnitVisible_65 := true;
        if Recounts = 66  then UnitVisible_66 := true;
        if Recounts = 67  then UnitVisible_67 := true;
        if Recounts = 68  then UnitVisible_68 := true;


        end;
        until ((ACAResultsBufferUnits.Next = 0) or (Recounts = 68));
        end;
        end;
        HeadersUpdated := true;
    end;

    var
        ACAResultsBufferUnits2: Record UnknownRecord78066;
        ACAResultMatrixFilters: Record UnknownRecord78067;
        HeadersUpdated: Boolean;
        ACAResultsBufferDetails: Record UnknownRecord78054;
        ProgFilters: Text[150];
        AcadYearFilters: Text[150];
        SemFilters: Text[150];
        CaptionArrays: array [68] of Code[20];
        UnitScores: array [68] of Decimal;
        ACAResultsBufferUnits: Record UnknownRecord78066;
        Recounts: Integer;
        UnitVisible_1: Boolean;
        UnitVisible_2: Boolean;
        UnitVisible_3: Boolean;
        UnitVisible_4: Boolean;
        UnitVisible_5: Boolean;
        UnitVisible_6: Boolean;
        UnitVisible_7: Boolean;
        UnitVisible_8: Boolean;
        UnitVisible_9: Boolean;
        UnitVisible_10: Boolean;
        UnitVisible_11: Boolean;
        UnitVisible_12: Boolean;
        UnitVisible_13: Boolean;
        UnitVisible_14: Boolean;
        UnitVisible_15: Boolean;
        UnitVisible_16: Boolean;
        UnitVisible_17: Boolean;
        UnitVisible_18: Boolean;
        UnitVisible_19: Boolean;
        UnitVisible_20: Boolean;
        UnitVisible_21: Boolean;
        UnitVisible_22: Boolean;
        UnitVisible_23: Boolean;
        UnitVisible_24: Boolean;
        UnitVisible_25: Boolean;
        UnitVisible_26: Boolean;
        UnitVisible_27: Boolean;
        UnitVisible_28: Boolean;
        UnitVisible_29: Boolean;
        UnitVisible_30: Boolean;
        UnitVisible_31: Boolean;
        UnitVisible_32: Boolean;
        UnitVisible_33: Boolean;
        UnitVisible_34: Boolean;
        UnitVisible_35: Boolean;
        UnitVisible_36: Boolean;
        UnitVisible_37: Boolean;
        UnitVisible_38: Boolean;
        UnitVisible_39: Boolean;
        UnitVisible_40: Boolean;
        UnitVisible_41: Boolean;
        UnitVisible_42: Boolean;
        UnitVisible_43: Boolean;
        UnitVisible_44: Boolean;
        UnitVisible_45: Boolean;
        UnitVisible_46: Boolean;
        UnitVisible_47: Boolean;
        UnitVisible_48: Boolean;
        UnitVisible_49: Boolean;
        UnitVisible_50: Boolean;
        UnitVisible_51: Boolean;
        UnitVisible_52: Boolean;
        UnitVisible_53: Boolean;
        UnitVisible_54: Boolean;
        UnitVisible_55: Boolean;
        UnitVisible_56: Boolean;
        UnitVisible_57: Boolean;
        UnitVisible_58: Boolean;
        UnitVisible_59: Boolean;
        UnitVisible_60: Boolean;
        UnitVisible_61: Boolean;
        UnitVisible_62: Boolean;
        UnitVisible_63: Boolean;
        UnitVisible_64: Boolean;
        UnitVisible_65: Boolean;
        UnitVisible_66: Boolean;
        UnitVisible_67: Boolean;
        UnitVisible_68: Boolean;

    local procedure ShowUnitDetails(Prog: Code[20];Units: Code[20];Stud: Code[20];AcademicYear: Code[20];Semester: Code[20])
    var
        ACAResultsBufferDetailsz: Record UnknownRecord78054;
    begin
        Clear(ACAResultsBufferDetailsz);
        ACAResultsBufferDetailsz.Reset;
        ACAResultsBufferDetailsz.SetRange(Programme,Prog);
        ACAResultsBufferDetailsz.SetRange("Unit Code",Units);
        ACAResultsBufferDetailsz.SetRange("Student No.",Stud);
        ACAResultsBufferDetailsz.SetRange(Semester,Semester);
        ACAResultsBufferDetailsz.SetRange("Academic Year",AcademicYear);
        if ACAResultsBufferDetailsz.Find('-') then begin
          Page.Run(78054,ACAResultsBufferDetailsz);
          end;
    end;
}

