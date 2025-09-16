#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51561 "Graduation List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Graduation List.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            column(ReportForNavId_6836; 6836)
            {
            }
            column(USERID;UserId)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Customer_Customer__No__;Customer."No.")
            {
            }
            column(TPassedUnits;TPassedUnits)
            {
            }
            column(TUnitsTaken_TPassedUnits;TUnitsTaken-TPassedUnits)
            {
            }
            column(Customer_Customer_Name;Customer.Name)
            {
            }
            column(Remark;Remark)
            {
            }
            column(RCount;RCount)
            {
            }
            column(TUnitsTaken;TUnitsTaken)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Pass_ListCaption;Pass_ListCaptionLbl)
            {
            }
            column(Units_PassedCaption;Units_PassedCaptionLbl)
            {
            }
            column(Units_FailedCaption;Units_FailedCaptionLbl)
            {
            }
            column(RemarkCaption;RemarkCaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(Customer_Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Units_TakenCaption;Units_TakenCaptionLbl)
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = "Student No."=field("No.");
                DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type");
                RequestFilterFields = Programme,Stage,Unit,"Student No.";
                column(ReportForNavId_2901; 2901)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RCount:=RCount+1;

                    PassedUnits:=0;
                    Grading.Reset;
                    Grading.SetRange(Grading.Category,'DEFAULT');
                    Grading.SetRange(Grading.Failed,true);
                    if Grading.Find('+') then
                    FailScore:=Grading."Up to";

                    StudUnits.Reset;
                    StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                    StudUnits.SetRange(StudUnits."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                    if StudUnits.Find('-') then begin
                    repeat
                    StudUnits.CalcFields(StudUnits."Total Score");
                    if StudUnits."Total Score" > FailScore then
                    PassedUnits:=PassedUnits+1;

                    until StudUnits.Next = 0;
                    end;


                    TPassedUnits:=TPassedUnits+PassedUnits;
                    TUnitsTaken:=TUnitsTaken+"ACA-Course Registration"."Units Taken";

                    if TPassedUnits = TPassedUnits then
                    Remark:='PASSED'
                    else
                    Remark:='FAILED';
                end;

                trigger OnPreDataItem()
                begin
                    RCount:=0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TPassedUnits:=0;
                TUnitsTaken:=0;
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
        Cust: Record Customer;
        Grading: Record UnknownRecord61569;
        StudUnits: Record UnknownRecord61549;
        FailScore: Decimal;
        PassedUnits: Integer;
        Remark: Text[150];
        RCount: Integer;
        TPassedUnits: Integer;
        TUnitsTaken: Integer;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Pass_ListCaptionLbl: label 'Pass List';
        Units_PassedCaptionLbl: label 'Units Passed';
        Units_FailedCaptionLbl: label 'Units Failed';
        RemarkCaptionLbl: label 'Remark';
        NamesCaptionLbl: label 'Names';
        Units_TakenCaptionLbl: label 'Units Taken';
}

