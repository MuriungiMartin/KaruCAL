#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 69272 "Staff Claims Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Staff Claims Report.rdlc';

    dataset
    {
        dataitem("Payments Header";UnknownTable61602)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_6437; 6437)
            {
            }
            column(Payments_Header__No__;"No.")
            {
            }
            column(Payments_Header_Payee;Payee)
            {
            }
            column(Payments_Header__Payments_Header__Date;"Payments Header".Date)
            {
            }
            column(Payments_Header__Global_Dimension_1_Code_;"Global Dimension 1 Code")
            {
            }
            column(Account_No;"Account No.")
            {
            }
            column(Payments_Header_Purpose;Purpose)
            {
            }
            column(PIC;company.Picture)
            {
            }
            column(DptName;DptName)
            {
            }
            column(USERID;UserId)
            {
            }
            column(NumberText_1_;NumberText[1])
            {
            }
            column(TTotal;TTotal)
            {
                DecimalPlaces = 2:2;
            }
            column(log;company.Picture)
            {
            }
            column(TIME_PRINTED_____FORMAT_TIME_;'TIME PRINTED:' + Format(Time))
            {
                AutoFormatType = 1;
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_;'DATE PRINTED:' + Format(Today,0,4))
            {
                AutoFormatType = 1;
            }
            column(CurrCode;CurrCode)
            {
            }
            column(STAFF_IMPREST_REQUESTCaption;STAFF_IMPREST_REQUESTCaptionLbl)
            {
            }
            column(KARATINA_UNIVERSITYSCaption;KARATINA_UNIVERSITYSCaptionLbl)
            {
            }
            column(PAYEMENT_DETAILSCaption;PAYEMENT_DETAILSCaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(Document_No__Caption;Document_No__CaptionLbl)
            {
            }
            column(Applicant_Caption;Applicant_CaptionLbl)
            {
            }
            column(Document_Date_Caption;Document_Date_CaptionLbl)
            {
            }
            column(Payments_Header__Global_Dimension_1_Code_Caption;FieldCaption("Global Dimension 1 Code"))
            {
            }
            column(Department_NameCaption;Department_NameCaptionLbl)
            {
            }
            column(Payee_Caption;Payee_CaptionLbl)
            {
            }
            column(Purpose_Caption;Purpose_CaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Printed_By_Caption;Printed_By_CaptionLbl)
            {
            }
            column(Amount_in_wordsCaption;Amount_in_wordsCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(Date_______________________________________Caption;Date_______________________________________CaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755003;EmptyStringCaption_Control1102755003Lbl)
            {
            }
            column(Signature_of_the_ApplicantCaption;Signature_of_the_ApplicantCaptionLbl)
            {
            }
            column(Date_______________________________________Caption_Control1102755005;Date_______________________________________Caption_Control1102755005Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755009;EmptyStringCaption_Control1102755009Lbl)
            {
            }
            column(Head_of_Dept_Vote_HolderCaption;Head_of_Dept_Vote_HolderCaptionLbl)
            {
            }
            column(Date_______________________________________Caption_Control1102755012;Date_______________________________________Caption_Control1102755012Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755013;EmptyStringCaption_Control1102755013Lbl)
            {
            }
            column(Accountant__in__Charge___DebtorsCaption;Accountant__in__Charge___DebtorsCaptionLbl)
            {
            }
            column(Date_______________________________________Caption_Control1102755016;Date_______________________________________Caption_Control1102755016Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755017;EmptyStringCaption_Control1102755017Lbl)
            {
            }
            column(Accountant_in_Charge_Vote_Book_ControlCaption;Accountant_in_Charge_Vote_Book_ControlCaptionLbl)
            {
            }
            column(Date_______________________________________Caption_Control1102755021;Date_______________________________________Caption_Control1102755021Lbl)
            {
            }
            column(EmptyStringCaption_Control1102755026;EmptyStringCaption_Control1102755026Lbl)
            {
            }
            column(Vice_Chancellor_DVCCaption;Vice_Chancellor_DVCCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755033;EmptyStringCaption_Control1102755033Lbl)
            {
            }
            column(SignatureCaption;SignatureCaptionLbl)
            {
            }
            column(ApprovalsCaption;ApprovalsCaptionLbl)
            {
            }
            dataitem("Payment Line";UnknownTable61603)
            {
                DataItemLink = No=field("No.");
                column(ReportForNavId_3474; 3474)
                {
                }
                column(Payment_Line_Amount;Amount)
                {
                }
                column(Account_No________Account_Name_;"Account No:"+':'+"Account Name")
                {
                }
                column(Payment_Line_No;No)
                {
                }
                column(Payment_Line_Account_No_;"Account No:")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DimVal.Reset;
                    DimVal.SetRange(DimVal."Global Dimension No.",2);
                    DimVal.SetRange(DimVal.Code,"Shortcut Dimension 2 Code");
                    DimValName:='';
                    if DimVal.FindFirst then
                      begin
                        DimValName:=DimVal.Name;
                      end;

                    TTotal:=TTotal + "Payment Line".Amount ;
                    CheckReport.InitTextVariable();
                    CheckReport.FormatNoText(NumberText,TTotal,'');
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StrCopyText:='';
                if "No. Printed">=1 then
                  begin
                    StrCopyText:='DUPLICATE';
                  end;
                TTotal:=0;


                //Set currcode to Default if blank
                GLSetup.Get();
                if "Payments Header"."Currency Code"='' then begin
                  CurrCode:=GLSetup."LCY Code";
                end else
                  CurrCode:="Payments Header"."Currency Code";

                //For Inv Curr Code
                if "Payments Header"."Invoice Currency Code"='' then begin
                  InvoiceCurrCode:=GLSetup."LCY Code";
                end else
                  InvoiceCurrCode:="Payments Header"."Invoice Currency Code";

                //End;
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code,"Payments Header"."Shortcut Dimension 2 Code");
                if DimVal.Find('-') then begin
                DptName:=DimVal.Name;
                end;
            end;

            trigger OnPostDataItem()
            begin
                if CurrReport.Preview=false then
                  begin
                    "No. Printed":="No. Printed" + 1;
                    Modify;
                  end;

                CheckReport.InitTextVariable();
                CheckReport.FormatNoText(NumberText,TTotal,'');
            end;

            trigger OnPreDataItem()
            begin

                LastFieldNo := FieldNo("No.");
                if company.Get() then begin
                  company.CalcFields(company.Picture);
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
        StrCopyText: Text[250];
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        DimVal: Record "Dimension Value";
        DimValName: Text[250];
        TTotal: Decimal;
        CheckReport: Report Check;
        NumberText: array [2] of Text[250];
        STotal: Decimal;
        InvoiceCurrCode: Code[40];
        CurrCode: Code[40];
        GLSetup: Record "General Ledger Setup";
        DptName: Code[250];
        STAFF_IMPREST_REQUESTCaptionLbl: label 'STAFF IMPREST REQUEST';
        KARATINA_UNIVERSITYSCaptionLbl: label 'KARATINA UNIVERSITY';
        PAYEMENT_DETAILSCaptionLbl: label 'PAYEMENT DETAILS';
        AmountCaptionLbl: label 'Amount';
        Document_No__CaptionLbl: label 'Document No.:';
        Applicant_CaptionLbl: label 'Applicant:';
        Document_Date_CaptionLbl: label 'Document Date:';
        Department_NameCaptionLbl: label 'Department Name';
        Payee_CaptionLbl: label 'Payee:';
        Purpose_CaptionLbl: label 'Purpose:';
        TotalCaptionLbl: label 'Total';
        Printed_By_CaptionLbl: label 'Printed By:';
        Amount_in_wordsCaptionLbl: label 'Amount in words';
        EmptyStringCaptionLbl: label '================================================================================================================================================================================================';
        Date_______________________________________CaptionLbl: label 'Date:______________________________________';
        EmptyStringCaption_Control1102755003Lbl: label '______________________________________________';
        Signature_of_the_ApplicantCaptionLbl: label 'Signature of the Applicant';
        Date_______________________________________Caption_Control1102755005Lbl: label 'Date:______________________________________';
        EmptyStringCaption_Control1102755009Lbl: label '______________________________________________';
        Head_of_Dept_Vote_HolderCaptionLbl: label 'Head of Dept/Vote Holder';
        Date_______________________________________Caption_Control1102755012Lbl: label 'Date:______________________________________';
        EmptyStringCaption_Control1102755013Lbl: label '______________________________________________';
        Accountant__in__Charge___DebtorsCaptionLbl: label 'Accountant- in- Charge - Debtors';
        Date_______________________________________Caption_Control1102755016Lbl: label 'Date:______________________________________';
        EmptyStringCaption_Control1102755017Lbl: label '______________________________________________';
        Accountant_in_Charge_Vote_Book_ControlCaptionLbl: label 'Accountant-in-Charge-Vote Book Control';
        Date_______________________________________Caption_Control1102755021Lbl: label 'Date:______________________________________';
        EmptyStringCaption_Control1102755026Lbl: label '______________________________________________';
        Vice_Chancellor_DVCCaptionLbl: label 'Vice Chancellor/DVC';
        EmptyStringCaption_Control1102755033Lbl: label '______________________';
        SignatureCaptionLbl: label 'Signature';
        ApprovalsCaptionLbl: label 'Approvals';
        company: Record "Company Information";
}

