--西行寺的甜点女仆✿魂魄妖梦
function c20248.initial_effect(c)
	--summon,flip,special
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c20248.retreg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--okashi
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20248,0))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetCountLimit(1,20248)
	e5:SetCost(c20248.descost)
	e5:SetTarget(c20248.destg)
	e5:SetOperation(c20248.desop)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(20248,1))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c20248.condition)
	e6:SetTarget(c20248.drtg)
	e6:SetOperation(c20248.drop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_BE_MATERIAL)
	e7:SetCondition(c20248.con2)
	c:RegisterEffect(e7)
end
function c20248.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(20248,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c20248.retcon)
	e1:SetTarget(c20248.rettg)
	e1:SetOperation(c20248.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c20248.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c20248.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c20248.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c20248.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c20248.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3 end
end
function c20248.filter(c)
	return c:IsType(TYPE_SPIRIT)
end
function c20248.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c20248.filter,1,1,nil)
		if sg:GetCount()>0 then
			if sg:GetFirst():IsAbleToHand() then
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			else
				Duel.SendtoGrave(sg,REASON_RULE)
			end
			Duel.SortDecktop(tp,tp,3)
		else
			Duel.SortDecktop(tp,tp,4)
		end
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_HAND)
		e1:SetCountLimit(1)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(c20248.tgop)
		e1:SetReset(RESET_EVENT+0x55c0000)
		c:RegisterEffect(e1)
	end
end
function c20248.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.SendtoGrave(c,REASON_EFFECT)
end
function c20248.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_BATTLE)
end
function c20248.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c20248.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,0)
end
function c20248.cfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c20248.drop(e,tp,eg,ep,ev,re,r,rp)
	local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local c1=Duel.GetMatchingGroupCount(c20248.cfilter,tp,LOCATION_MZONE,0,nil)
	local c2=Duel.GetMatchingGroupCount(c20248.cfilter,tp,0,LOCATION_MZONE,nil)
	if h1<c2 then
		Duel.Draw(tp,c2-h1,REASON_EFFECT)
	end
	if h2<c1 then
		Duel.Draw(1-tp,c1-h2,REASON_EFFECT)
	end
end
