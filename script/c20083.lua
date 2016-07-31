 
--苍天的庭师✿魂魄妖梦
function c20083.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c20083.spcon)
	e1:SetOperation(c20083.spop)
	c:RegisterEffect(e1)
	--summon,flip,special
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c20083.retreg)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e5:SetTarget(c20083.reptg)
	e5:SetValue(c20083.repval)
	c:RegisterEffect(e5)
end
function c20083.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetDecktopGroup(tp,2)
	local remv=g:FilterCount(Card.IsAbleToRemoveAsCost,nil)>1
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and remv
end
function c20083.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x208) and c:IsType(TYPE_SPIRIT)
end
function c20083.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetDecktopGroup(tp,2)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local rg=Duel.GetOperatedGroup()
	local ct=rg:FilterCount(c20083.filter,nil,nil)
	if ct==0 then
		e:GetHandler():RegisterFlagEffect(20083,RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c20083.retreg(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(20083)>0 then
		Duel.Destroy(c,REASON_EFFECT)
	end
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetDescription(aux.Stringid(20083,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetReset(RESET_EVENT+0x1ee0000+RESET_PHASE+PHASE_END)
	e1:SetCondition(c20083.retcon)
	e1:SetTarget(c20083.rettg)
	e1:SetOperation(c20083.retop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	c:RegisterEffect(e2)
end
function c20083.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(EFFECT_SPIRIT_DONOT_RETURN) then return false end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		return not c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN)
	else return c:IsHasEffect(EFFECT_SPIRIT_MAYNOT_RETURN) end
end
function c20083.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c20083.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
function c20083.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x208) and c:IsType(TYPE_SPIRIT)
end
function c20083.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c20083.repfilter,1,nil,tp) end
	if e:GetHandler():IsAbleToRemove() and Duel.SelectYesNo(tp,aux.Stringid(20083,1)) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		local g=eg:Filter(c20083.repfilter,nil,tp)
		if g:GetCount()==1 then
			e:SetLabelObject(g:GetFirst())
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
			local cg=g:Select(tp,1,1,nil)
			e:SetLabelObject(cg:GetFirst())
		end
		return true
	else return false end
end
function c20083.repval(e,c)
	return c==e:GetLabelObject()
end
