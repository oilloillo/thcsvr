--幼小的恶魔之眼✿幽玄魔眼
function c11026.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11026,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCondition(c11026.spcon)
	e1:SetCost(c11026.cost)
	e1:SetTarget(c11026.sptg)
	e1:SetOperation(c11026.spop)
	c:RegisterEffect(e1)
	--n.e.t.o.r.a.r.e.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11026,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCondition(c11026.descon)
	e2:SetCost(c11026.ntcost)
	e2:SetTarget(c11026.target)
	e2:SetOperation(c11026.operation)
	c:RegisterEffect(e2)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c11026.sumsuc)
	c:RegisterEffect(e4)
end
function c11026.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c11026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c11026.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,LOCATION_GRAVE)
end
function c11026.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11026.descon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local ct2=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	return ct1<ct2
end
function c11026.ntcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c11026.filter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler() and not c:IsType(TYPE_TOKEN)
end
function c11026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c11026.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11026.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c11026.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(aux.FALSE)
end
function c11026.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c11026.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
