#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68944 "HMS-Setup Card List"
{
    CardPageID = "HMS-Setup Card";
    PageType = Card;
    SourceTable = UnknownTable61386;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Caption = 'General';
                field("Patient Nos";"Patient Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Appointment Nos";"Appointment Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Nos";"Observation Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Visit Nos";"Visit Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Lab Test Request Nos";"Lab Test Request Nos")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Test Nos';
                }
                field("Radiology Nos";"Radiology Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Pharmacy Nos";"Pharmacy Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Request Nos";"Admission Request Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Referral Nos";"Referral Nos")
                {
                    ApplicationArea = Basic;
                }
            }
            repeater(Pharmacies)
            {
                Caption = 'Pharmacies';
                field("Pharmacy Item Journal Template";"Pharmacy Item Journal Template")
                {
                    ApplicationArea = Basic;
                }
                field("Pharmacy Item Journal Batch";"Pharmacy Item Journal Batch")
                {
                    ApplicationArea = Basic;
                }
                field("Pharmacy Location";"Pharmacy Location")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Room";"Observation Room")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Item Journal Temp";"Observation Item Journal Temp")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Item Journal Batch";"Observation Item Journal Batch")
                {
                    ApplicationArea = Basic;
                }
                field("Doctor Room";"Doctor Room")
                {
                    ApplicationArea = Basic;
                }
                field("Doctor Item Journal Template";"Doctor Item Journal Template")
                {
                    ApplicationArea = Basic;
                }
                field("Doctor Item Journal Batch";"Doctor Item Journal Batch")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Room";"Laboratory Room")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Item Journal Temp";"Laboratory Item Journal Temp")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Item Journal Batch";"Laboratory Item Journal Batch")
                {
                    ApplicationArea = Basic;
                }
            }
            repeater(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill Students";"Bill Students")
                {
                    ApplicationArea = Basic;
                }
                field("Bill Employees";"Bill Employees")
                {
                    ApplicationArea = Basic;
                }
                field("Bill Other Categories";"Bill Other Categories")
                {
                    ApplicationArea = Basic;
                }
                field("Limit Of Next Of Kin";"Limit Of Next Of Kin")
                {
                    ApplicationArea = Basic;
                }
                field("Limit Age Of Next Of Kin(Yrs)";"Limit Age Of Next Of Kin(Yrs)")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

