--No Name 蕾蒂西亚·德克雷亚
function c71105.initial_effect(c)
	--检索
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetTarget(c71105.sptg2)
	e2:SetOperation(c71105.spop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--特殊召唤规则
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,71105)
	e4:SetCode(EFFECT_SPSUMMON_PROC)
	e4:SetCondition(c71105.hspcon)
	e4:SetOperation(c71105.hspop)
	c:RegisterEffect(e4)
	end
function c71105.filter(c)
	return  c:IsCode(71201) and c:IsAbleToHand()
end
function c71105.filter2(c)
	return  c:IsSetCard(0x711) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c71105.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71105.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71105.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71105.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	local g=Duel.GetMatchingGroup(c71105.filter2,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(71105,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c71105.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),Card.IsSetCard,1,nil,0x711)
end
function c71105.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),Card.IsSetCard,1,1,nil,0x711)
	Duel.Release(g,REASON_COST)
	c:RegisterFlagEffect(0,RESET_EVENT+0x4fc0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(71105,2))
end