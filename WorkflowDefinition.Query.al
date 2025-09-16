#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Query 1502 "Workflow Definition"
{
    Caption = 'Workflow Definition';
    OrderBy = ascending(Sequence_No);

    elements
    {
        dataitem(Workflow;Workflow)
        {
            column("Code";"Code")
            {
            }
            column(Workflow_Description;Description)
            {
            }
            column(Enabled;Enabled)
            {
            }
            column(Template;Template)
            {
            }
            dataitem(Workflow_Step;"Workflow Step")
            {
                DataItemLink = "Workflow Code"=Workflow.Code;
                column(ID;ID)
                {
                }
                column(Step_Description;Description)
                {
                }
                column(Entry_Point;"Entry Point")
                {
                }
                column(Type;Type)
                {
                }
                column(Function_Name;"Function Name")
                {
                }
                column(Argument;Argument)
                {
                }
                column(Sequence_No;"Sequence No.")
                {
                }
                dataitem(Workflow_Event;"Workflow Event")
                {
                    DataItemLink = "Function Name"=Workflow_Step."Function Name";
                    column(Table_ID;"Table ID")
                    {
                    }
                }
            }
        }
    }
}

