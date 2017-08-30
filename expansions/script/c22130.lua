 
--巴瓦鲁魔法图书馆
function c22130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c22130.activate)
	c:RegisterEffect(e1)
	--search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22130,1))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PREDRAW)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c22130.condition)
	e5:SetTarget(c22130.target)
	e5:SetOperation(c22130.operation)
	c:RegisterEffect(e5)
end
function c22130.cffilter(c)
	return ((c:IsSetCard(0x177) and c:IsType(TYPE_SPELL)) or c:IsCode(22017)) and not c:IsPublic()
end
function c22130.spfilter(c,e,tp)
	return c:IsSetCard(0x111) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22130.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c22130.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
	local cg=Duel.GetMatchingGroup(c22130.cffilter,tp,LOCATION_HAND,0,nil)
	if g:GetCount()>0 and cg:GetCount()>1 and Duel.SelectYesNo(tp,aux.Stringid(22130,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local rg=cg:Select(tp,2,2,nil)
		Duel.ConfirmCards(1-tp,rg)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 and Duel.SelectYesNo(tp,aux.Stringid(22130,2)) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(TYPE_TUNER)
			sg:GetFirst():RegisterEffect(e1)
		end
	end
end
function c22130.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetDrawCount(tp)>0
end
function c22130.filter(c)
	return c:IsSetCard(0x177) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function c22130.filter1(c,g)
	return g:IsExists(Card.IsCode,1,c,c:GetCode())
end
function c22130.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c22130.filter,tp,LOCATION_DECK,0,nil)
		return g:IsExists(c22130.filter1,1,nil,g) end
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_DECK)
end
function c22130.operation(e,tp,eg,ep,ev,re,r,rp)
	_replace_count=_replace_count+1
	if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) or e:GetHandler():IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c22130.filter,tp,LOCATION_DECK,0,nil)
	local sg=g:Filter(c22130.filter1,nil,g)
	if sg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=sg:Select(tp,1,1,nil)
	local g2=sg:Filter(Card.IsCode,g1:GetFirst(),g1:GetFirst():GetCode()):GetFirst()
	g1:AddCard(g2)
	Duel.SendtoHand(g1,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end
