#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68834 "ACA-Fee Structure Per Unit"
{
    PageType = List;
    SourceTable = UnknownTable61652;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Programme Code";"Programme Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Amount Per Unit";"Amount Per Unit")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Programme Name";"Programme Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Settlement Desc.";"Settlement Desc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Student)
            {
                Caption = 'Student';
                action("Post Fee Structure")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Fee Structure';
                    Image = "Action";
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                         if Confirm('Are you sure you want to Update the Fee Structure?\This may take afew minutes. Continue?',true)=false then exit;

                        Feestruct.Reset;
                        Feestruct.SetFilter(Feestruct."Amount Per Unit",'>%1',0);
                        if Feestruct.Find('-') then begin
                           repeat
                           begin
                            ProgSem.Reset;
                            ProgSem.SetRange(ProgSem."Programme Code",Feestruct."Programme Code");
                            if ProgSem.Find('-') then begin
                            ProgressWindow.Open('Proccessing Fee Structure for #1#####################################');
                            repeat
                              begin
                               ProgressWindow.Update(1,Feestruct."Programme Code"+' '+Feestruct."Programme Name");
                               Sleep(100);
                                if Feestruct.Type = Feestruct.Type::lumpsum then begin
                                 StageFee.Reset;
                                 StageFee.SetRange(StageFee."Programme Code",ProgSem."Programme Code");
                                 StageFee.SetRange(StageFee.Semester,ProgSem.Semester);
                                 if Feestruct."Student Type" = 'Full Time' then
                                   StageFee.SetRange(StageFee."Student Type",0)
                                                  else if Feestruct."Student Type" = 'Part Time' then
                                   StageFee.SetRange(StageFee."Student Type",1)
                                                  else if Feestruct."Student Type" = 'ODL' then
                                   StageFee.SetRange(StageFee."Student Type",2)
                                                  else if Feestruct."Student Type" = 'SB' then
                                   StageFee.SetRange(StageFee."Student Type",3);
                                   StageFee.SetRange(StageFee."Settlemet Type",Feestruct."Settlement Type");
                                   if StageFee.Find('-') then StageFee.DeleteAll;
                                            ProgStages.Reset;
                                            ProgStages.SetRange(ProgStages."Programme Code",Feestruct."Programme Code");
                                            if ProgStages.Find('-') then
                                              begin
                                              repeat
                                                begin
                                                  StageFee.Init;
                                                  StageFee."Programme Code":=Feestruct."Programme Code";
                                                  StageFee."Stage Code":=ProgStages.Code;
                                                  StageFee.Semester:=ProgSem.Semester;
                                                  StageFee."Settlemet Type":=Feestruct."Student Type";
                                                  if Feestruct."Student Type" = 'Full Time' then
                                                  StageFee."Student Type":=0
                                                  else if Feestruct."Student Type" = 'Part Time' then
                                                  StageFee."Student Type":=1
                                                  else if Feestruct."Student Type" = 'ODL' then
                                                  StageFee."Student Type":=2
                                                  else if Feestruct."Student Type" = 'SB' then
                                                  StageFee."Student Type":=3;
                                                  StageFee."Seq.":=1;
                                                  StageFee."Break Down":=Feestruct."Amount Per Unit";
                                                  StageFee.Insert();
                                                end;
                                              until ProgStages.Next = 0;
                                              end; // if ProgStages.find('-') then
                                   end else if Feestruct.Type = Feestruct.Type::"Per Unit" then begin


                                   UnitFee.Reset;
                                   UnitFee.SetRange(UnitFee."Programme Code",ProgSem."Programme Code");
                                   UnitFee.SetRange(UnitFee.Semester,ProgSem.Semester);
                                                  if Feestruct."Student Type" = 'Full Time' then
                                   UnitFee.SetRange(UnitFee."Student Type",UnitFee."student type"::"Full Time")
                                                  else if Feestruct."Student Type" = 'Part Time' then
                                   UnitFee.SetRange(UnitFee."Student Type",UnitFee."student type"::"Part Time")
                                                  else if Feestruct."Student Type" = 'ODL' then
                                   UnitFee.SetRange(UnitFee."Student Type",UnitFee."student type"::"Distance Learning");
                                               //   ELSE IF Feestruct."Settlement Type" = 'SB' THEN
                                  // UnitFee.SETRANGE(UnitFee."Student Type",UnitFee."Student Type"::"School Based");

                                   UnitFee.SetRange(UnitFee."Settlemet Type",Feestruct."Settlement Type");
                                   if UnitFee.Find('-') then UnitFee.DeleteAll;
                                            ProgStages.Reset;
                                            ProgStages.SetRange(ProgStages."Programme Code",Feestruct."Programme Code");
                                            if ProgStages.Find('-') then
                                              begin
                                              repeat
                                                begin
                                                ProgUnits.Reset;
                                                ProgUnits.SetRange(ProgUnits."Programme Code",Feestruct."Programme Code");
                                                ProgUnits.SetRange(ProgUnits."Stage Code",ProgStages.Code);
                                                if ProgUnits.Find('-') then begin
                                                repeat
                                                begin
                                               UnitFee.Reset;
                                               UnitFee.SetRange(UnitFee."Programme Code",Feestruct."Programme Code");
                                               UnitFee.SetRange(UnitFee."Stage Code",ProgStages.Code);
                                               UnitFee.SetRange(UnitFee."Unit Code",ProgUnits.Code);
                                               UnitFee.SetRange(UnitFee.Semester,ProgSem.Semester);
                                               if Feestruct."Student Type" = 'Full Time' then
                                               UnitFee.SetRange(UnitFee."Student Type",UnitFee."student type"::"Full Time")
                                               else if Feestruct."Student Type" = 'Part Time' then
                                               UnitFee.SetRange(UnitFee."Student Type",UnitFee."student type"::"Part Time")
                                               else if Feestruct."Student Type" = 'ODL' then
                                               UnitFee.SetRange(UnitFee."Student Type",UnitFee."student type"::"Distance Learning");
                                             //  ELSE IF Feestruct."Settlement Type" = 'SB' THEN
                                             //  UnitFee.SETRANGE(UnitFee."Student Type",UnitFee."Student Type"::"School Based");

                                               UnitFee.SetRange(UnitFee."Settlemet Type",Feestruct."Settlement Type");
                                                if UnitFee.Find('-') then
                                                  UnitFee.DeleteAll;

                                                  UnitFee.Init;
                                                  UnitFee."Programme Code":=Feestruct."Programme Code";
                                                  UnitFee."Stage Code":=ProgStages.Code;
                                                  UnitFee."Unit Code":=ProgUnits.Code;
                                                  UnitFee.Semester:=ProgSem.Semester;
                                                  UnitFee."Settlemet Type":=Feestruct."Settlement Type";
                                                  if Feestruct."Student Type" = 'Full Time' then
                                                  UnitFee."Student Type":=UnitFee."student type"::"Full Time"
                                                  else if Feestruct."Student Type" = 'Part Time' then
                                                  UnitFee."Student Type":=UnitFee."student type"::"Part Time"
                                                  else if Feestruct."Student Type" = 'ODL' then
                                                  UnitFee."Student Type":=UnitFee."student type"::"Distance Learning";
                                               //   ELSE IF Feestruct."Settlement Type" = 'SB' THEN
                                                //  UnitFee."Student Type":=UnitFee."Student Type"::"School Based";
                                                  UnitFee."Seq.":=1;
                                                  UnitFee."Break Down":=Feestruct."Amount Per Unit";
                                                  UnitFee.Insert();
                                                 end;
                                                 until ProgUnits.Next = 0;
                                                 end; //  if ProgUnits.fin('-') then
                                                end;
                                              until ProgStages.Next = 0;
                                              end; // if ProgStages.find('-') then

                                   end;// end if Feestruct.Type = Feestruct.Type::LUMPSUM then begin
                                end;
                                until ProgSem.Next=0;
                                ProgressWindow.Close();
                                end;
                            end;
                            until Feestruct.Next =0;
                            end;

                        Message('The Fee Structure has Been Updated successfully.');
                    end;
                }
            }
        }
    }

    var
        Feestruct: Record UnknownRecord61652;
        ProgSem: Record UnknownRecord61525;
        StageFee: Record UnknownRecord61523;
        UnitFee: Record UnknownRecord61524;
        ProgStages: Record UnknownRecord61516;
        ProgUnits: Record UnknownRecord61517;
        ProgressWindow: Dialog;
}

