#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78125 "Fund Band Batch Card"
{
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Fund Band Batch";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Student Count";"Student Count")
                {
                    ApplicationArea = Basic;
                }
                field("Created DateTime";"Created DateTime")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Close;Close)
                {
                    ApplicationArea = Basic;
                    Caption = 'Closed';
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000007;"Band Entries ListPart")
            {
                SubPageLink = "Batch No."=field("Document No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Import Entries")
            {
                ApplicationArea = Basic;
                Enabled = not Archived;
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Batches: Record "Fund Band Batch";
                begin
                    TestField("Academic Year");
                    Batches.Reset;
                    Batches.SetRange(Close,false);
                    Batches.SetRange(Archived,false);
                    Batches.SetFilter("Document No.",'<>%1',Rec."Document No.");
                    if Batches.Count>0 then
                      Error('You have %1 unclosed batches. Close before proceeding',Batches.Count);
                    Clear(ImportBands);
                                        ImportBands.getheader(Rec);
                                        ImportBands.Run();
                end;
            }
            action(Archive)
            {
                ApplicationArea = Basic;
                Enabled = not Archived;
                Image = Archive;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    if not Confirm('Do you want to archive this batch? This action cannot be undone!') then
                      exit;
                    Rec.Archived:=true;
                    Rec.Validate(Archived);
                    Rec.Close:=true;
                    Rec.Modify;
                    Message('Entries for this batch have been archived');
                end;
            }
        }
    }

    var
        ImportBands: XmlPort "Import/export Band Entries";
}

