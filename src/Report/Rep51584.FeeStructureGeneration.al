#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51584 "Fee Structure Generation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Fee Structure Generation.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code","Stage Filter","Semester Filter","Settlement Type Filter";
            column(ReportForNavId_1410; 1410)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programme_Category;Category)
            {
            }
            column(Master_Fee_UpdateCaption;Master_Fee_UpdateCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Programme_CategoryCaption;FieldCaption(Category))
            {
            }
            column(FE;"ACA-Programme"."Tuition Fees")
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code),Code=field("Stage Filter");
                DataItemTableView = sorting("Programme Code",Code) order(ascending);
                column(ReportForNavId_3691; 3691)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    MasterFee.Reset;
                    if MasterFee.Find('-') then begin
                    FeeByStage.Reset;
                    FeeByStage.SetRange(FeeByStage."Programme Code","ACA-Programme Stages"."Programme Code");
                    FeeByStage.SetRange(FeeByStage."Stage Code","ACA-Programme Stages".Code);
                    FeeByStage.SetRange(FeeByStage."Settlemet Type",MasterFee."Settlemet Type");
                    FeeByStage.SetFilter(FeeByStage.Semester,"ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                    if FeeByStage.Find('-') then
                    FeeByStage.DeleteAll;

                    repeat
                    FeeByStage.Init;
                    FeeByStage."Programme Code":="ACA-Programme Stages"."Programme Code";
                    FeeByStage."Stage Code":="ACA-Programme Stages".Code;
                    FeeByStage.Semester:="ACA-Programme".GetFilter("ACA-Programme"."Semester Filter");
                    FeeByStage."Student Type":=MasterFee."Student Type";
                    FeeByStage."Settlemet Type":=MasterFee."Settlemet Type";
                    FeeByStage."Seq.":=MasterFee."Seq.";
                    FeeByStage."Break Down":=MasterFee."Break Down";
                    FeeByStage."Amount Not Distributed":=MasterFee."Amount Not Distributed";
                    FeeByStage.Insert;


                    until MasterFee.Next = 0;
                    end;


                    StageC.Reset;
                    StageC.SetRange(StageC."Programme Code","ACA-Programme Stages"."Programme Code");
                    StageC.SetRange(StageC."Stage Code","ACA-Programme Stages".Code);
                    StageC.SetFilter(StageC.Semester,"ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                    StageC.SetFilter(StageC."Settlement Type","ACA-Programme".GetFilter("Settlement Type Filter"));
                    if StageC.Find('-') then
                    StageC.DeleteAll;


                    MasterCharges.Reset;
                    MasterCharges.SetRange(MasterCharges."First Time Students",false);
                    MasterCharges.SetRange(MasterCharges."First Semster Only",false);
                    if MasterCharges.Find('-') then begin
                    repeat

                    StageC.Init;
                    StageC."Programme Code":="ACA-Programme Stages"."Programme Code";
                    StageC."Stage Code":="ACA-Programme Stages".Code;
                    StageC.Code:=MasterCharges.Code;
                    StageC.Semester:="ACA-Programme".GetFilter("ACA-Programme"."Semester Filter");
                    StageC.Description:=MasterCharges.Description;
                    StageC.Amount:=MasterCharges.Amount;
                    StageC."Student Type":=MasterCharges."Student Type";
                    StageC."Recovery Priority":=MasterCharges."Recovery Priority";
                    StageC."Distribution (%)":=MasterCharges."Distribution (%)";
                    StageC."Distribution Account":=MasterCharges."Distribution Account";
                    StageC."Settlement Type":="ACA-Programme".GetFilter("Settlement Type Filter");
                    StageC.Insert;

                    until MasterCharges.Next = 0;

                    end;


                    if CopyStr("ACA-Programme Stages".Code,3,2) = 'S1' then begin
                    MasterCharges.Reset;
                    MasterCharges.SetRange(MasterCharges."First Time Students",false);
                    MasterCharges.SetRange(MasterCharges."First Semster Only",true);
                    if MasterCharges.Find('-') then begin
                    repeat

                    StageC.Init;
                    StageC."Programme Code":="ACA-Programme Stages"."Programme Code";
                    StageC."Stage Code":="ACA-Programme Stages".Code;
                    StageC.Code:=MasterCharges.Code;
                    StageC.Description:=MasterCharges.Description;
                    StageC.Semester:="ACA-Programme".GetFilter("ACA-Programme"."Semester Filter");
                    StageC.Amount:=MasterCharges.Amount;
                    StageC."Student Type":=MasterCharges."Student Type";
                    StageC."Recovery Priority":=MasterCharges."Recovery Priority";
                    StageC."Distribution (%)":=MasterCharges."Distribution (%)";
                    StageC."Distribution Account":=MasterCharges."Distribution Account";
                    StageC."Settlement Type":="ACA-Programme".GetFilter("Settlement Type Filter");
                    StageC.Insert;

                    until MasterCharges.Next = 0;

                    end;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                 /*
                NewSCharges.RESET;
                NewSCharges.SETRANGE(NewSCharges."Programme Code",Programme.Code);
                NewSCharges.SETFILTER(NewSCharges.Code,"Programme Stages".GETFILTER("Programme Stages".Code));
                IF NewSCharges.FIND('-') THEN
                NewSCharges.DELETEALL;
                 */
                /* IF Programme.GETFILTER(Programme."Settlement Type Filter")= '' THEN
                 ERROR('Please select the Settlement type filter');  */
                
                MasterCharges.Reset;
                MasterCharges.SetRange(MasterCharges."First Time Students",true);
                if MasterCharges.Find('-') then begin
                repeat
                NewSCharges."Programme Code":="ACA-Programme".Code;
                NewSCharges.Code:=MasterCharges.Code;
                NewSCharges.Description:=MasterCharges.Description;
                NewSCharges.Amount:=MasterCharges.Amount;
                NewSCharges."First Time Students":=MasterCharges."First Time Students";
                NewSCharges."Student Type":=MasterCharges."Student Type";
                NewSCharges."Recovery Priority":=MasterCharges."Recovery Priority";
                NewSCharges."Distribution (%)":=MasterCharges."Distribution (%)";
                NewSCharges."Distribution Account":=MasterCharges."Distribution Account";
                NewSCharges.Insert;
                
                until MasterCharges.Next = 0;
                end;

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

    var
        FeeByStage: Record UnknownRecord61523;
        StageC: Record UnknownRecord61533;
        NewSCharges: Record UnknownRecord61543;
        MasterFee: Record UnknownRecord61555;
        MasterCharges: Record UnknownRecord61556;
        Master_Fee_UpdateCaptionLbl: label 'Master Fee Update';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

