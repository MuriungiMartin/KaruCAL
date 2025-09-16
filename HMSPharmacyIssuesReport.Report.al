#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51396 "HMS Pharmacy Issues Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Pharmacy Issues Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61424;UnknownTable61424)
        {
            DataItemTableView = sorting("Pharmacy No.","Drug No.");
            RequestFilterFields = "Pharmacy No.";
            column(ReportForNavId_1251; 1251)
            {
            }
            column(Date_Printed_____FORMAT_TODAY_0_4_;'Date Printed:' + Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Printed_By______USERID;'Printed By: ' + UserId)
            {
            }
            column(HMS_Pharmacy_Line__Pharmacy_No__;"Pharmacy No.")
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
            column(HMS_Pharmacy_Line__Measuring_Unit_;"Measuring Unit")
            {
            }
            column(HMS_Pharmacy_Line__Actual_Qty_;"Actual Qty")
            {
            }
            column(HMS_Pharmacy_Line__Issued_Quantity_;"Issued Quantity")
            {
            }
            column(HMS_Pharmacy_Line__Issued_Units_;"Issued Units")
            {
            }
            column(HMS_Pharmacy_Line_Pharmacy;Pharmacy)
            {
            }
            column(HMS_Pharmacy_Line_Remaining;Remaining)
            {
            }
            column(PFNo;PFNo)
            {
            }
            column(PatientName;PatientName)
            {
            }
            column(HMS_Pharmacy_Line_Date;Date)
            {
            }
            column(HMS_Pharmacy_Line_Dosage;Dosage)
            {
            }
            column(Number_of_Drug_Issues_Listed______FORMAT__HMS_Pharmacy_Line__COUNT_;'Number of Drug Issues Listed: ' + Format("HMS-Pharmacy Line".Count))
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(PHARMACY_ISSUES_LISTING_REPORTCaption;PHARMACY_ISSUES_LISTING_REPORTCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(HMS_Pharmacy_Line__Drug_No__Caption;FieldCaption("Drug No."))
            {
            }
            column(HMS_Pharmacy_Line__Drug_Name_Caption;FieldCaption("Drug Name"))
            {
            }
            column(HMS_Pharmacy_Line_QuantityCaption;FieldCaption(Quantity))
            {
            }
            column(UOMCaption;UOMCaptionLbl)
            {
            }
            column(HMS_Pharmacy_Line__Actual_Qty_Caption;FieldCaption("Actual Qty"))
            {
            }
            column(Issued_QtyCaption;Issued_QtyCaptionLbl)
            {
            }
            column(Iss__UnitsCaption;Iss__UnitsCaptionLbl)
            {
            }
            column(HMS_Pharmacy_Line_PharmacyCaption;FieldCaption(Pharmacy))
            {
            }
            column(HMS_Pharmacy_Line_RemainingCaption;FieldCaption(Remaining))
            {
            }
            column(PF_No_Caption;PF_No_CaptionLbl)
            {
            }
            column(Patient_nameCaption;Patient_nameCaptionLbl)
            {
            }
            column(HMS_Pharmacy_Line_DateCaption;FieldCaption(Date))
            {
            }
            column(HMS_Pharmacy_Line_DosageCaption;FieldCaption(Dosage))
            {
            }

            trigger OnAfterGetRecord()
            begin
                Patient.Reset;
                PFNo:='';
                PatientName:='';
                Header.Reset;
                Header.Get("Pharmacy No.");
                if Patient.Get(Header."Patient No.") then
                  begin
                    PatientName:=Patient.Surname + ' ' + Patient."Middle Name" +' ' + Patient."Last Name";
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
        Header: Record UnknownRecord61423;
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        PHARMACY_ISSUES_LISTING_REPORTCaptionLbl: label 'PHARMACY ISSUES LISTING REPORT';
        No_CaptionLbl: label 'No.';
        UOMCaptionLbl: label 'UOM';
        Issued_QtyCaptionLbl: label 'Issued Qty';
        Iss__UnitsCaptionLbl: label 'Iss. Units';
        PF_No_CaptionLbl: label 'PF/No.';
        Patient_nameCaptionLbl: label 'Patient name';
}

