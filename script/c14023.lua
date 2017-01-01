--Good Apple??
function c14023.initial_effect(c)
	--lv
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14023,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,14023+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c14023.cost)
	e1:SetTarget(c14023.lvtg)
	e1:SetOperation(c14023.lvop)
	c:RegisterEffect(e1)
	--chiren
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14023,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,14023+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c14023.ccost)
	e2:SetOperation(c14023.activate)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(14023,ACTIVITY_SPSUMMON,c14023.counterfilter)
end
function c14023.counterfilter(c)
	return c:IsSetCard(0x138)
end
function c14023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c14023.filter(c)
	return c:IsSetCard(0x138) and c:GetLevel()>2
end
function c14023.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14023.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c14023.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(14023,2))
	local g=Duel.SelectMatchingCard(tp,c14023.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+0xfe0000)
		g:GetFirst():RegisterEffect(e1)
	end
end
function c14023.ccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) and Duel.GetCustomActivityCount(14023,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.PayLPCost(tp,500)
	--oath effects
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c14023.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c14023.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x138)
end
function c14023.activate(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	Duel.SetLP(tp,lp-500)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_RELEASE_SUM)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
