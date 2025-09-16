#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78069 "ACA-Semester Buffered Progs."
{
    PageType = List;
    SourceTable = UnknownTable78068;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prog. Code";"Prog. Code")
                {
                    ApplicationArea = Basic;
                }
                field("Prog. Name";"Prog. Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Buffered Stages";"Buffered Stages")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(UpdateProgStages)
            {
                ApplicationArea = Basic;
                Caption = 'Update Programs/Stages';
                Image = UpdateShipment;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    ACAResultsBufferProgrammes: Record UnknownRecord78068;
                    ACAResultsBufferProgStage: Record UnknownRecord78069;
                    ACAProgramme: Record UnknownRecord61511;
                    ACAProgrammeStages: Record UnknownRecord61516;
                begin
                    if Confirm('Update programs?',true) = false then Error('Canceled!');
                    Clear(ACAProgramme);
                    ACAProgramme.Reset;
                    if ACAProgramme.Find('-') then begin
                      repeat
                        begin
                        ACAResultsBufferProgrammes.Init;
                        ACAResultsBufferProgrammes."Semester Code":= "Semester Code";
                        ACAResultsBufferProgrammes."Prog. Code" := ACAProgramme.Code;
                        if ACAResultsBufferProgrammes.Insert then;
                          Clear(ACAProgrammeStages);
                          ACAProgrammeStages.Reset;
                          ACAProgrammeStages.SetRange("Programme Code",ACAProgramme.Code);
                          if ACAProgrammeStages.Find('-') then begin
                              repeat
                                begin
                                ACAResultsBufferProgStage.Init;
                                ACAResultsBufferProgStage."Semester Code" := Rec."Semester Code";
                                ACAResultsBufferProgStage."Prog. Code" := ACAProgrammeStages."Programme Code";
                                ACAResultsBufferProgStage."Stage Code" := ACAProgrammeStages.Code;
                                if ACAResultsBufferProgStage.Insert then;
                                end;
                                until ACAProgrammeStages.Next=0;
                            end;
                        end;
                        until ACAProgramme.Next = 0;
                      end;
                      Message('Posted!');
                end;
            }
        }
    }
}

