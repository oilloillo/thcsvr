--名誉『十二阶之冠位』
function c27093.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(27093,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c27093.target)
	e1:SetOperation(c27093.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(27093,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,27092)
	e2:SetTarget(c27093.tg)
	e2:SetOperation(c27093.op)
	c:RegisterEffect(e2)
end
function c27093.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsCanBeEffectTarget()
end
function c27093.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(c27093.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>0
		and g:CheckWithSumEqual(Card.GetLevel,6,1,12) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=g:SelectWithSumEqual(tp,Card.GetLevel,6,1,99)
	Duel.SetTargetCard(sg)
	--e:SetLabel(sg:GetCount())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c27093.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ct=tg:GetCount()
	if ct==0 then return end
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,ct,ct,nil)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)

		local fc = tg:GetFirst()
		local sc = tg:GetNext()
		local function ftarget(e,c)
			return c ~= fc and c ~= sc
		end 

		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(ftarget)
		-- e1:SetLabelObject(tg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
-- function c27093.ftarget(e,c)
-- 	return not e:GetLabelObject():IsExists(c)
-- end
function c27093.thfilter(c)
	return c:IsCode(27092) and c:IsAbleToHand()
end
function c27093.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27093.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27093.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c27093.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
