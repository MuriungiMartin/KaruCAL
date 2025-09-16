#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68961 "HMS-Immunization Posted List"
{
    CardPageID = "HMS Immunization Posted";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61437;
    SourceTableView = where(Posted=const(Yes));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Immunization Date";"Immunization Date")
                {
                    ApplicationArea = Basic;
                }
                field("Immunization Time";"Immunization Time")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        Patient.Reset;
                        if Patient.Get("Patient No.") then
                          begin
                            "Patient Name":=Patient.Surname + ' ' + Patient."Middle Name" + ' ' + Patient."Last Name";
                          end;
                    end;
                }
                field("Patient Name";"Patient Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Immunization No.";"Immunization No.")
                {
                    ApplicationArea = Basic;
                }
                field("Immunization Name";"Immunization Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Given;Given)
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        Patient: Record UnknownRecord61402;
        Imm: Record UnknownRecord61437;
}

