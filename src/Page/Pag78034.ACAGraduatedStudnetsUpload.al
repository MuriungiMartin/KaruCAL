#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78034 "ACA-Graduated Studnets Upload"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable78034;
    SourceTableView = where(Posted=filter(No));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Year";"Graduation Year")
                {
                    ApplicationArea = Basic;
                }
                field("Certificate Number";"Certificate Number")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Date";"Graduation Date")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Post)
            {
                ApplicationArea = Basic;
                Caption = 'Post';
                Image = PostedReceipts;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('Post?',true)=false then Error('Cancelled by user!');
                    ACAGraduatedStudentsUpload.Reset;
                    ACAGraduatedStudentsUpload.SetRange(Posted,false);
                    //ACAGraduatedStudentsUpload.SETRANGE("Certificate Number",'<>%1','');
                    if not (ACAGraduatedStudentsUpload.Find('-')) then Error('Nothing to Post');
                    repeat
                      begin
                        Customer.Reset;
                        Customer.SetRange("No.",ACAGraduatedStudentsUpload."Student No.");
                        if Customer.Find('-') then begin
                            Customer.Status:=Customer.Status::Alumni;
                            ACAGraduatedStudentsUpload.Posted:=true;
                            //Customer."Certificate No.":=ACAGraduatedStudentsUpload."Certificate Number";
                            Customer.Modify;
                          end;
                      end;
                        until ACAGraduatedStudentsUpload.Next= 0;
                end;
            }
            action("Import Graduates")
            {
                ApplicationArea = Basic;

                trigger OnAction()
                begin
                    if Confirm('Import Graduands',true)=false then exit;
                    Xmlport.Run(50168,false,true);
                end;
            }
        }
    }

    var
        ACAGraduatedStudentsUpload: Record UnknownRecord78034;
        Customer: Record Customer;
}

