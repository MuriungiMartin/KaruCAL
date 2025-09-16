#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51395 "HMS Pharmacy List Detailed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Pharmacy List Detailed.rdlc';

    dataset
    {
        dataitem(UnknownTable61423;UnknownTable61423)
        {
            DataItemTableView = sorting("Pharmacy No.");
            RequestFilterFields = "Pharmacy No.";
            column(ReportForNavId_7110; 7110)
            {
            }
            column(DATE_PRINTED_____FORMAT_TODAY_0_4_;'DATE PRINTED:' + Format(Today,0,4))
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(PRINTED_BY______USERID;'PRINTED BY: ' + UserId)
            {
            }
            column(HMS_Pharmacy_Header__Pharmacy_No__;"Pharmacy No.")
            {
            }
            column(HMS_Pharmacy_Header__Pharmacy_Date_;"Pharmacy Date")
            {
            }
            column(PFNo;PFNo)
            {
            }
            column(HMS_Pharmacy_Header__Issued_By_;"Issued By")
            {
            }
            column(PatientName;PatientName)
            {
            }
            column(HMS_Pharmacy_Header_Status;Status)
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(PHARMACY_LISTING_REPORTCaption;PHARMACY_LISTING_REPORTCaptionLbl)
            {
            }
            column(HMS_Pharmacy_Line__Drug_No__Caption;"HMS-Pharmacy Line".FieldCaption("Drug No."))
            {
            }
            column(HMS_Pharmacy_Line__Drug_Name_Caption;"HMS-Pharmacy Line".FieldCaption("Drug Name"))
            {
            }
            column(HMS_Pharmacy_Line_DosageCaption;"HMS-Pharmacy Line".FieldCaption(Dosage))
            {
            }
            column(StoreCaption;StoreCaptionLbl)
            {
            }
            column(QtyCaption;QtyCaptionLbl)
            {
            }
            column(Actl_QtyCaption;Actl_QtyCaptionLbl)
            {
            }
            column(Issued_QtyCaption;Issued_QtyCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(HMS_Pharmacy_Header__Issued_By_Caption;FieldCaption("Issued By"))
            {
            }
            column(PFNoCaption;PFNoCaptionLbl)
            {
            }
            column(Patient_nameCaption;Patient_nameCaptionLbl)
            {
            }
            column(HMS_Pharmacy_Header_StatusCaption;FieldCaption(Status))
            {
            }
            dataitem(UnknownTable61424;UnknownTable61424)
            {
                DataItemLink = "Pharmacy No."=field("Pharmacy No.");
                column(ReportForNavId_1251; 1251)
                {
                }
                column(HMS_Pharmacy_Line__Drug_No__;"Drug No.")
                {
                }
                column(HMS_Pharmacy_Line__Drug_Name_;"Drug Name")
                {
                }
                column(HMS_Pharmacy_Line_Quantity;Quantity)
                {
                }
                column(HMS_Pharmacy_Line__Actual_Qty_;"Actual Qty")
                {
                }
                column(HMS_Pharmacy_Line__Issued_Quantity_;"Issued Quantity")
                {
                }
                column(HMS_Pharmacy_Line_Dosage;Dosage)
                {
                }
                column(HMS_Pharmacy_Line_Pharmacy;Pharmacy)
                {
                }
                column(HMS_Pharmacy_Line_Pharmacy_No_;"Pharmacy No.")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PatientName:='';
                PFNo:='';
                if Patient.Get("Patient No.") then
                  begin
                    PatientName:=Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
                    if Patient."Patient Type"=Patient."patient type"::Others then
                      begin
                        PFNo:=Patient."Student No.";
                      end
                    else if Patient."Patient Type"=Patient."patient type"::" " then
                      begin
                        PFNo:=Patient."Patient No.";
                      end
                    else
                      begin
                        PFNo:=Patient."Employee No.";
                      end;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Pharmacy No.");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Patient: Record UnknownRecord61402;
        PFNo: Code[20];
        PatientName: Text[200];
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        PHARMACY_LISTING_REPORTCaptionLbl: label 'PHARMACY LISTING REPORT';
        StoreCaptionLbl: label 'Store';
        QtyCaptionLbl: label 'Qty';
        Actl_QtyCaptionLbl: label 'Actl Qty';
        Issued_QtyCaptionLbl: label 'Issued Qty';
        No_CaptionLbl: label 'No.';
        DateCaptionLbl: label 'Date';
        PFNoCaptionLbl: label 'Label1102760018';
        Patient_nameCaptionLbl: label 'Patient name';
}

