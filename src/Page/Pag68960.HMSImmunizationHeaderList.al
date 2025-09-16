#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68960 "HMS-Immunization Header List"
{
    CardPageID = "HMS Immunization Header";
    PageType = List;
    SourceTable = UnknownTable61437;
    SourceTableView = where(Posted=const(No));

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
        area(processing)
        {
            action("&Post Immunizations")
            {
                ApplicationArea = Basic;
                Caption = '&Post Immunizations';
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if Confirm('Do you wish to make the Immunization records permanent?',false)=false then begin exit end;
                    Imm.Reset;
                    Imm.SetRange(Imm.Posted,false);
                    Imm.SetRange(Imm.Select,true);
                    if Imm.Find('-') then
                      begin
                        repeat
                          Imm.Posted:=true;
                          Imm.Select:=false;
                          Imm.Modify;
                        until Imm.Next=0;
                        Message('Immunization records made permanent');
                      end;
                end;
            }
        }
    }

    var
        Patient: Record UnknownRecord61402;
        Imm: Record UnknownRecord61437;
}

