--命运的阴暗面✿键山雏
function c23070.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x208),1)
	c:EnableReviveLimit()
	--extra to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(23070,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,23070+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c23070.con)
	e2:SetTarget(c23070.tg)
	e2:SetOperation(c23070.op)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23070,1))
	e3:SetCategory(CATEGORY_DECKDES+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c23070.target)
	e3:SetOperation(c23070.operation)
	c:RegisterEffect(e3)
end
function c23070.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c23070.filter(c)
	return c:IsAbleToGrave() and c:GetLevel()<8 and c:GetRank()<8
end
function c23070.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c23070.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,3,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_EXTRA)
end
function c23070.op(e,tp,eg,ep,ev,re,r,rp)
	local cg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_EXTRA,nil)
	if cg:GetCount()>0 then Duel.ConfirmCards(tp,cg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c23070.filter,tp,LOCATION_EXTRA,LOCATION_EXTRA,3,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c23070.rvfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c23070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and Duel.IsExistingMatchingCard(c23070.rvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(c23070.rvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c23070.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENCE)
		local og=Duel.GetOperatedGroup()
		local gc=og:FilterCount(Card.IsPosition,nil,POS_FACEDOWN_DEFENCE)
		if gc>0 then
			Duel.DiscardDeck(tp,gc,REASON_EFFECT)
			Duel.DiscardDeck(1-tp,gc,REASON_EFFECT)
		end
	end
end
